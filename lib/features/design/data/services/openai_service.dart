import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/constants/api_constants.dart';

class RoomAnalysis {
  final String description;
  final String roomType;
  final String currentStyle;
  final String dimensions;
  final String existingFeatures;

  const RoomAnalysis({
    required this.description,
    required this.roomType,
    required this.currentStyle,
    required this.dimensions,
    required this.existingFeatures,
  });
}

class OpenAIService {
  final ApiClient _apiClient;

  OpenAIService(this._apiClient);

  // ── API Key Validation ──────────────────────────────────────────────────
  Future<bool> validateApiKey() async {
    try {
      await _apiClient.post(
        ApiConstants.chatCompletionsEndpoint,
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'user', 'content': 'Hi'},
          ],
          'max_tokens': 1,
        },
      );
      return true;
    } on AuthException {
      return false;
    } catch (_) {
      rethrow;
    }
  }

  // ── Room Analysis with GPT-4 Vision ─────────────────────────────────────
  Future<RoomAnalysis> analyzeRoom(File image) async {
    return _retryWithBackoff(() async {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _apiClient.post(
        ApiConstants.chatCompletionsEndpoint,
        data: {
          'model': ApiConstants.gpt4VisionModel,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text':
                      'Analyze this room photo in detail. Describe:\n'
                      '1. Room type (living room, bedroom, kitchen, etc.)\n'
                      '2. Current furniture and their positions\n'
                      '3. Wall colors and materials\n'
                      '4. Flooring type\n'
                      '5. Lighting (natural/artificial, direction)\n'
                      '6. Room dimensions estimate\n'
                      '7. Notable architectural features (windows, doors, ceiling height)\n'
                      'Be specific and descriptive for use in interior design generation.',
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image',
                    'detail': 'high',
                  },
                },
              ],
            },
          ],
          'max_tokens': 500,
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;
      return RoomAnalysis(
        description: content,
        roomType: 'detected',
        currentStyle: 'detected',
        dimensions: 'standard',
        existingFeatures: content,
      );
    });
  }

  // ── Design Generation: tries GPT-4o image gen first, falls back to DALL-E 3
  Future<String> generateDesign({
    RoomAnalysis? analysis,
    required String styleKeyword,
    required String roomTypeKeyword,
    String? customPrompt,
    bool isGarden = false,
    File? sourceImage,
  }) async {
    return _retryWithBackoff(() async {
      if (sourceImage != null) {
        try {
          return await _generateWithImageReference(
            sourceImage: sourceImage,
            analysis: analysis,
            styleKeyword: styleKeyword,
            roomTypeKeyword: roomTypeKeyword,
            customPrompt: customPrompt,
            isGarden: isGarden,
          );
        } catch (e) {
          // If gpt-image-1 fails (e.g. not available on this key tier),
          // fall through to DALL-E 3 with analysis context
        }
      }

      return await _generateWithDalle3(
        analysis: analysis,
        styleKeyword: styleKeyword,
        roomTypeKeyword: roomTypeKeyword,
        customPrompt: customPrompt,
        isGarden: isGarden,
      );
    });
  }

  // ── GPT-image-1 (photo edit via /images/edits multipart) ────────────────
  Future<String> _generateWithImageReference({
    required File sourceImage,
    RoomAnalysis? analysis,
    required String styleKeyword,
    required String roomTypeKeyword,
    String? customPrompt,
    bool isGarden = false,
  }) async {
    final prompt = _buildTransformPrompt(
      analysis: analysis,
      styleKeyword: styleKeyword,
      roomTypeKeyword: roomTypeKeyword,
      customPrompt: customPrompt,
      isGarden: isGarden,
    );

    final formData = FormData.fromMap({
      'model': 'gpt-image-1',
      'prompt': prompt,
      'n': '1',
      'size': '1024x1024',
      'image': await MultipartFile.fromFile(
        sourceImage.path,
        filename: 'room.jpg',
      ),
    });

    final response = await _apiClient.postMultipart(
      ApiConstants.imageEditsEndpoint,
      formData: formData,
    );

    // gpt-image-1 returns base64
    final b64 = response.data['data'][0]['b64_json'] as String?;
    if (b64 != null) {
      return await _saveBase64Image(b64);
    }

    return response.data['data'][0]['url'] as String;
  }

  // ── DALL-E 3 text-only fallback ──────────────────────────────────────────
  Future<String> _generateWithDalle3({
    RoomAnalysis? analysis,
    required String styleKeyword,
    required String roomTypeKeyword,
    String? customPrompt,
    bool isGarden = false,
  }) async {
    final prompt = _buildPrompt(
      analysis: analysis,
      styleKeyword: styleKeyword,
      roomTypeKeyword: roomTypeKeyword,
      customPrompt: customPrompt,
      isGarden: isGarden,
    );

    final response = await _apiClient.post(
      ApiConstants.imageGenerationEndpoint,
      data: {
        'model': ApiConstants.dalle3Model,
        'prompt': prompt,
        'n': 1,
        'size': '1024x1024',
        'quality': 'hd',
      },
    );

    return response.data['data'][0]['url'] as String;
  }

  // ── Prompt: photo-based transformation ──────────────────────────────────
  String _buildTransformPrompt({
    RoomAnalysis? analysis,
    required String styleKeyword,
    required String roomTypeKeyword,
    String? customPrompt,
    bool isGarden = false,
  }) {
    final buffer = StringBuffer();

    if (isGarden) {
      buffer.write(
        'Transform this outdoor space into a professionally designed garden '
        'in $styleKeyword style. '
        'Keep the exact same camera angle, perspective, and spatial layout. '
        'Preserve the boundaries and structural elements of the space. ',
      );
    } else {
      buffer.write(
        'Redesign this exact room in $styleKeyword interior design style. '
        'Keep the same room layout, camera angle, perspective, wall positions, '
        'windows, doors, and ceiling height. '
        'Replace the furniture, decor, colors, and materials to match '
        '$styleKeyword style while preserving the room\'s architecture. ',
      );
    }

    if (analysis != null && analysis.existingFeatures.isNotEmpty) {
      buffer.write(
        'The room currently has: ${analysis.existingFeatures}. '
        'Transform these elements to fit the new style. ',
      );
    }

    final styleDetails = _stylePromptMap[styleKeyword.toLowerCase()];
    if (styleDetails != null) {
      buffer.write('$styleDetails ');
    }

    if (customPrompt != null && customPrompt.isNotEmpty) {
      buffer.write('Additional requirements: $customPrompt. ');
    }

    buffer.write(
      'Ultra-realistic result, photorealistic rendering, '
      'professional interior photography quality, '
      'natural lighting consistent with the original photo, '
      'high detail, 4K quality.',
    );

    return buffer.toString();
  }

  // ── Prompt: DALL-E 3 text-only (with analysis context) ──────────────────
  String _buildPrompt({
    RoomAnalysis? analysis,
    required String styleKeyword,
    required String roomTypeKeyword,
    String? customPrompt,
    bool isGarden = false,
  }) {
    final buffer = StringBuffer();

    if (isGarden) {
      buffer.write(
        'Professional landscape design photograph of a $roomTypeKeyword '
        'redesigned in $styleKeyword style. ',
      );
      if (analysis != null) {
        buffer.write(
          'Based on this space: ${analysis.existingFeatures}. '
          'Maintain the property boundaries while transforming the landscape. ',
        );
      }
      buffer.write(
        'Lush vegetation, professional landscaping, golden hour lighting, '
        'architectural digest quality. ',
      );
    } else {
      buffer.write(
        'Professional interior design photograph of a $roomTypeKeyword '
        'completely redesigned in $styleKeyword style. ',
      );
      if (analysis != null) {
        buffer.write(
          'Room details: ${analysis.existingFeatures}. '
          'Maintain the room layout and dimensions while transforming the aesthetic. ',
        );
      }
    }

    final styleDetails = _stylePromptMap[styleKeyword.toLowerCase()];
    if (styleDetails != null) {
      buffer.write('$styleDetails ');
    }

    if (customPrompt != null && customPrompt.isNotEmpty) {
      buffer.write('Additional requirements: $customPrompt. ');
    }

    buffer.write(
      'Ultra-realistic, 4K quality, architectural photography, '
      'natural lighting, award-winning interior design, '
      'editorial quality, depth of field, professionally staged, '
      'shot on Hasselblad, interior design magazine cover quality.',
    );

    return buffer.toString();
  }

  // ── Style-specific prompt enhancements ──────────────────────────────────
  static const Map<String, String> _stylePromptMap = {
    'modern': 'Clean lines, neutral palette with bold accents, open floor plan, '
        'sleek furniture, glass and steel elements, geometric shapes.',
    'minimalist': 'Extreme simplicity, monochromatic palette, essential furniture only, '
        'negative space, hidden storage, zen-like tranquility.',
    'scandinavian': 'Light wood tones, white walls, hygge warmth, wool textures, '
        'simple functional furniture, potted plants, cozy textiles.',
    'industrial': 'Exposed brick walls, metal fixtures, Edison bulbs, concrete floors, '
        'raw materials, pipe shelving, distressed leather.',
    'bohemian': 'Rich colors, layered textiles, macrame, global patterns, '
        'eclectic furniture mix, floor cushions, hanging plants.',
    'classic': 'Symmetrical layouts, crown molding, chandeliers, rich wood furniture, '
        'traditional patterns, silk drapery, antique accents.',
    'japanese': 'Shoji screens, tatami elements, natural materials, zen garden influence, '
        'minimal ornamentation, bamboo accents, paper lanterns.',
    'art deco': 'Geometric patterns, gold and black palette, velvet upholstery, '
        'mirrored surfaces, bold statement pieces, glamorous lighting.',
    'mid-century modern': 'Organic curves, tapered legs, teak wood, iconic chairs, '
        'retro color palette, starburst clocks, open layouts.',
    'coastal': 'White and blue palette, natural textures, rattan furniture, '
        'driftwood accents, sheer curtains, ocean-inspired decor.',
    'rustic': 'Reclaimed wood, stone fireplace, wrought iron, handcrafted details, '
        'warm earth tones, cozy cabin atmosphere.',
    'tropical': 'Palm prints, vibrant greens, bamboo furniture, natural fibers, '
        'indoor-outdoor flow, exotic plants, rattan accents.',
    'contemporary': 'Current trends, mixed materials, bold artwork, '
        'streamlined furniture, neutral base with color pops, layered lighting.',
    'traditional': 'Rich wood paneling, ornate details, symmetrical arrangements, '
        'classic upholstery, formal dining settings, elegant drapery.',
    'farmhouse': 'Shiplap walls, barn doors, apron sink, distressed wood, '
        'mason jar accents, gingham patterns, vintage charm.',
  };

  // ── Save base64 image to local file ─────────────────────────────────────
  Future<String> _saveBase64Image(String base64Data) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'generated_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${dir.path}/$filename';
    final bytes = base64Decode(base64Data);
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  // ── Image Download ──────────────────────────────────────────────────────
  Future<String> downloadImage(String url, String filename) async {
    // Already a local path (base64 was saved directly)
    if (!url.startsWith('http')) return url;
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$filename';
    await _apiClient.downloadFile(url, filePath);
    return filePath;
  }

  // ── Retry with Exponential Backoff ──────────────────────────────────────
  Future<T> _retryWithBackoff<T>(
    Future<T> Function() action, {
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await action();
      } on AuthException {
        rethrow;
      } on RateLimitException {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 1 << attempt));
      } on ServerException {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 1 << attempt));
      } on TimeoutException {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 1 << attempt));
      }
    }
  }
}
