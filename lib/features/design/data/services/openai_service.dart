import 'dart:convert';
import 'dart:io';
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
      // Network or other errors - key might be valid but can't verify
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
                      'Analyze this room photo concisely. Provide:\n'
                      '1. Room type (e.g., living room, bedroom)\n'
                      '2. Current style\n'
                      '3. Estimated dimensions\n'
                      '4. Key furniture and elements present\n'
                      '5. Lighting conditions\n'
                      'Be brief and factual.',
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image',
                    'detail': 'low',
                  },
                },
              ],
            },
          ],
          'max_tokens': 300,
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

  // ── Design Generation with DALL-E 3 ────────────────────────────────────
  Future<String> generateDesign({
    RoomAnalysis? analysis,
    required String styleKeyword,
    required String roomTypeKeyword,
    String? customPrompt,
    bool isGarden = false,
  }) async {
    return _retryWithBackoff(() async {
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
    });
  }

  // ── Professional Prompt Engineering ─────────────────────────────────────
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
          'Current outdoor features: ${analysis.existingFeatures}. '
          'Maintain the property boundaries while transforming the landscape design. ',
        );
      }
      buffer.write(
        'Lush vegetation, professional landscaping, golden hour lighting, '
        'architectural digest quality, beautifully maintained garden paths, '
        'outdoor furniture arrangement. ',
      );
    } else {
      buffer.write(
        'Professional interior design photograph of a $roomTypeKeyword '
        'redesigned in $styleKeyword style. ',
      );
      if (analysis != null) {
        buffer.write(
          'Current room features: ${analysis.existingFeatures}. '
          'Maintain the room layout and dimensions while transforming the aesthetic. ',
        );
      }
    }

    // Per-style enhancements
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

  // ── Image Download ──────────────────────────────────────────────────────
  Future<String> downloadImage(String url, String filename) async {
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
        rethrow; // No point retrying a bad key
      } on RateLimitException {
        attempt++;
        if (attempt >= maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 1 << attempt)); // 2s, 4s, 8s
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
