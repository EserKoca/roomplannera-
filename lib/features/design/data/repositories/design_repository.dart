import 'dart:async';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../services/openai_service.dart';
import '../models/design_style.dart';
import '../models/room_type.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';

// ── Design Result Model ───────────────────────────────────────────────────
class DesignResult {
  final String id;
  final String originalImagePath;
  final String generatedImagePath;
  final String styleId;
  final String styleName;
  final String roomTypeId;
  final String roomTypeName;
  final String? customPrompt;
  final bool isFavorite;
  final DateTime createdAt;
  final bool isDemo;

  DesignResult({
    required this.id,
    required this.originalImagePath,
    required this.generatedImagePath,
    required this.styleId,
    required this.styleName,
    required this.roomTypeId,
    required this.roomTypeName,
    this.customPrompt,
    this.isFavorite = false,
    required this.createdAt,
    this.isDemo = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'originalImagePath': originalImagePath,
    'generatedImagePath': generatedImagePath,
    'styleId': styleId,
    'styleName': styleName,
    'roomTypeId': roomTypeId,
    'roomTypeName': roomTypeName,
    'customPrompt': customPrompt,
    'isFavorite': isFavorite,
    'createdAt': createdAt.toIso8601String(),
    'isDemo': isDemo,
  };

  factory DesignResult.fromJson(Map<String, dynamic> json) => DesignResult(
    id: json['id'] as String,
    originalImagePath: json['originalImagePath'] as String,
    generatedImagePath: json['generatedImagePath'] as String,
    styleId: json['styleId'] as String,
    styleName: json['styleName'] as String,
    roomTypeId: json['roomTypeId'] as String,
    roomTypeName: json['roomTypeName'] as String,
    customPrompt: json['customPrompt'] as String?,
    isFavorite: json['isFavorite'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    isDemo: json['isDemo'] as bool? ?? false,
  );

  DesignResult copyWith({bool? isFavorite}) => DesignResult(
    id: id,
    originalImagePath: originalImagePath,
    generatedImagePath: generatedImagePath,
    styleId: styleId,
    styleName: styleName,
    roomTypeId: roomTypeId,
    roomTypeName: roomTypeName,
    customPrompt: customPrompt,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt,
    isDemo: isDemo,
  );
}

// ── Design Repository ─────────────────────────────────────────────────────
class DesignRepository {
  final OpenAIService _openAIService;
  final Box _designsBox;
  final Box _settingsBox;
  final _uuid = const Uuid();

  DesignResult? _lastResult;
  DesignResult? get lastResult => _lastResult;

  bool _isCancelled = false;

  DesignRepository(this._openAIService, this._designsBox, this._settingsBox);

  /// Returns the active API key (settings box takes priority, .env as fallback)
  String get activeApiKey {
    final savedKey = _settingsBox.get('openai_api_key', defaultValue: '') as String;
    if (savedKey.isNotEmpty) return savedKey;
    return dotenv.env['OPENAI_API_KEY'] ?? '';
  }

  bool get hasApiKey {
    final key = activeApiKey;
    return key.isNotEmpty && key.startsWith('sk-');
  }

  // ── Stream-based generation with progress ────────────────────────────
  Stream<GenerationProgress> createDesignWithProgress({
    required String imagePath,
    required DesignStyle style,
    required RoomType roomType,
    String? customPrompt,
    bool isGarden = false,
  }) async* {
    yield* _createRealDesign(
      imagePath: imagePath,
      style: style,
      roomType: roomType,
      customPrompt: customPrompt,
      isGarden: isGarden,
    );
  }

  // ── Real Generation (With API Key) ─────────────────────────────────
  Stream<GenerationProgress> _createRealDesign({
    required String imagePath,
    required DesignStyle style,
    required RoomType roomType,
    String? customPrompt,
    bool isGarden = false,
  }) async* {
    _isCancelled = false;
    _lastResult = null;

    try {
      // Stage 1: Analyzing
      yield const GenerationProgress(
        stage: GenerationStage.analyzing,
        progress: 0.05,
      );

      if (_isCancelled) return;

      RoomAnalysis? analysis;
      try {
        analysis = await _openAIService.analyzeRoom(File(imagePath));
      } catch (e) {
        analysis = null;
      }

      yield const GenerationProgress(
        stage: GenerationStage.analyzing,
        progress: 0.25,
      );

      if (_isCancelled) return;

      // Stage 2: Generating design
      yield const GenerationProgress(
        stage: GenerationStage.generating,
        progress: 0.33,
      );

      final imageUrl = await _openAIService.generateDesign(
        analysis: analysis,
        styleKeyword: style.promptKeyword,
        roomTypeKeyword: roomType.promptKeyword,
        customPrompt: customPrompt,
        isGarden: isGarden,
        sourceImage: File(imagePath),
      );

      yield const GenerationProgress(
        stage: GenerationStage.generating,
        progress: 0.65,
      );

      if (_isCancelled) return;

      // Stage 3: Downloading image
      yield const GenerationProgress(
        stage: GenerationStage.downloading,
        progress: 0.75,
      );

      final id = _uuid.v4();
      final localPath = await _openAIService.downloadImage(
        imageUrl,
        'design_$id.jpg',
      );

      yield const GenerationProgress(
        stage: GenerationStage.downloading,
        progress: 0.90,
      );

      if (_isCancelled) return;

      // Stage 4: Saving
      yield const GenerationProgress(
        stage: GenerationStage.saving,
        progress: 0.93,
      );

      final result = DesignResult(
        id: id,
        originalImagePath: imagePath,
        generatedImagePath: localPath,
        styleId: style.id,
        styleName: style.name,
        roomTypeId: roomType.id,
        roomTypeName: roomType.name,
        customPrompt: customPrompt,
        createdAt: DateTime.now(),
        isDemo: false,
      );

      await _designsBox.put(id, result.toJson());
      _incrementDesignCount();
      _lastResult = result;

      yield const GenerationProgress(
        stage: GenerationStage.complete,
        progress: 1.0,
      );
    } on AuthException {
      yield const GenerationProgress(
        stage: GenerationStage.error,
        errorMessage: 'Invalid API key. Please check your Settings.',
        canRetry: false,
      );
    } on RateLimitException {
      yield const GenerationProgress(
        stage: GenerationStage.error,
        errorMessage: 'Rate limit exceeded. Please wait a moment and try again.',
        canRetry: true,
      );
    } on NetworkException {
      yield const GenerationProgress(
        stage: GenerationStage.error,
        errorMessage: 'No internet connection. Please check your network.',
        canRetry: true,
      );
    } on TimeoutException {
      yield const GenerationProgress(
        stage: GenerationStage.error,
        errorMessage: 'Request timed out. Please try again.',
        canRetry: true,
      );
    } catch (e) {
      yield GenerationProgress(
        stage: GenerationStage.error,
        errorMessage: 'Something went wrong: $e',
        canRetry: true,
      );
    }
  }

  void cancelGeneration() {
    _isCancelled = true;
  }

  // ── Legacy createDesign (wraps stream) ──────────────────────────────
  Future<DesignResult?> createDesign({
    required String imagePath,
    required DesignStyle style,
    required RoomType roomType,
    String? customPrompt,
  }) async {
    await for (final progress in createDesignWithProgress(
      imagePath: imagePath,
      style: style,
      roomType: roomType,
      customPrompt: customPrompt,
    )) {
      if (progress.stage == GenerationStage.complete) {
        return _lastResult;
      }
      if (progress.stage == GenerationStage.error) {
        throw ApiException(progress.errorMessage ?? 'Generation failed');
      }
    }
    return null;
  }

  // ── Design Count / Free Tier ────────────────────────────────────────
  int getDesignCount() {
    return _settingsBox.get('design_count', defaultValue: 0) as int;
  }

  void _incrementDesignCount() {
    final current = getDesignCount();
    _settingsBox.put('design_count', current + 1);
  }

  // Paywall devre dışı — sınırsız erişim
  bool canGenerateDesign() => true;

  int getRemainingDesigns() => -1; // -1 = unlimited

  // ── CRUD Operations ─────────────────────────────────────────────────
  List<DesignResult> getAllDesigns() {
    return _designsBox.values
        .map(
          (e) => DesignResult.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  DesignResult? getDesignById(String id) {
    final data = _designsBox.get(id);
    if (data == null) return null;
    return DesignResult.fromJson(Map<String, dynamic>.from(data as Map));
  }

  Future<void> toggleFavorite(String id) async {
    final data = _designsBox.get(id);
    if (data != null) {
      final result =
          DesignResult.fromJson(Map<String, dynamic>.from(data as Map));
      final updated = result.copyWith(isFavorite: !result.isFavorite);
      await _designsBox.put(id, updated.toJson());
    }
  }

  Future<void> deleteDesign(String id) async {
    final data = _designsBox.get(id);
    if (data != null) {
      final result =
          DesignResult.fromJson(Map<String, dynamic>.from(data as Map));
      try {
        final genFile = File(result.generatedImagePath);
        if (await genFile.exists()) await genFile.delete();
      } catch (_) {}
      await _designsBox.delete(id);
    }
  }

  Future<void> clearAll() async {
    for (final entry in _designsBox.values) {
      try {
        final result =
            DesignResult.fromJson(Map<String, dynamic>.from(entry as Map));
        final genFile = File(result.generatedImagePath);
        if (await genFile.exists()) await genFile.delete();
      } catch (_) {}
    }
    await _designsBox.clear();
  }
}

// ── Riverpod Providers ────────────────────────────────────────────────────
final apiKeyProvider = StateProvider<String>((ref) {
  final savedKey = Hive.box('settings').get('openai_api_key', defaultValue: '') as String;
  if (savedKey.isNotEmpty) return savedKey;
  return dotenv.env['OPENAI_API_KEY'] ?? '';
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final apiKey = ref.watch(apiKeyProvider);
  return ApiClient(apiKey: apiKey.isNotEmpty ? apiKey : null);
});

final openAIServiceProvider = Provider<OpenAIService>((ref) {
  return OpenAIService(ref.watch(apiClientProvider));
});

final designRepositoryProvider = Provider<DesignRepository>((ref) {
  return DesignRepository(
    ref.watch(openAIServiceProvider),
    Hive.box('designs'),
    Hive.box('settings'),
  );
});
