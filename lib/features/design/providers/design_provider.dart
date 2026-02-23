import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/design_style.dart';
import '../data/models/room_type.dart';
import '../data/repositories/design_repository.dart';
import '../../../../core/network/api_exceptions.dart';

class DesignFlowState {
  final DesignStyle? selectedStyle;
  final RoomType? selectedRoomType;
  final String? imagePath;
  final String? customPrompt;
  final String? resultImagePath;
  final String? designCategory; // 'room' or 'garden'

  // ── Generation state ──────────────────────────────────────────────────
  final GenerationStage generationStage;
  final double generationProgress;
  final String? errorMessage;
  final bool canRetry;
  final String? designId;
  final String? originalImagePath;
  final String? generatedImagePath;

  const DesignFlowState({
    this.selectedStyle,
    this.selectedRoomType,
    this.imagePath,
    this.customPrompt,
    this.resultImagePath,
    this.designCategory,
    this.generationStage = GenerationStage.idle,
    this.generationProgress = 0.0,
    this.errorMessage,
    this.canRetry = false,
    this.designId,
    this.originalImagePath,
    this.generatedImagePath,
  });

  DesignFlowState copyWith({
    DesignStyle? selectedStyle,
    RoomType? selectedRoomType,
    String? imagePath,
    String? customPrompt,
    String? resultImagePath,
    String? designCategory,
    GenerationStage? generationStage,
    double? generationProgress,
    String? errorMessage,
    bool? canRetry,
    String? designId,
    String? originalImagePath,
    String? generatedImagePath,
    bool clearError = false,
  }) {
    return DesignFlowState(
      selectedStyle: selectedStyle ?? this.selectedStyle,
      selectedRoomType: selectedRoomType ?? this.selectedRoomType,
      imagePath: imagePath ?? this.imagePath,
      customPrompt: customPrompt ?? this.customPrompt,
      resultImagePath: resultImagePath ?? this.resultImagePath,
      designCategory: designCategory ?? this.designCategory,
      generationStage: generationStage ?? this.generationStage,
      generationProgress: generationProgress ?? this.generationProgress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      canRetry: canRetry ?? this.canRetry,
      designId: designId ?? this.designId,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      generatedImagePath: generatedImagePath ?? this.generatedImagePath,
    );
  }

  bool get canGenerate =>
      selectedStyle != null && selectedRoomType != null && imagePath != null;

  bool get isGenerating =>
      generationStage != GenerationStage.idle &&
      generationStage != GenerationStage.complete &&
      generationStage != GenerationStage.error;

  bool get hasError => generationStage == GenerationStage.error;

  bool get isComplete => generationStage == GenerationStage.complete;
}

class DesignFlowNotifier extends StateNotifier<DesignFlowState> {
  DesignFlowNotifier() : super(const DesignFlowState());

  StreamSubscription<GenerationProgress>? _generationSub;

  void selectStyle(DesignStyle style) =>
      state = state.copyWith(selectedStyle: style);

  void selectRoomType(RoomType type) =>
      state = state.copyWith(selectedRoomType: type);

  void setImage(String path) => state = state.copyWith(imagePath: path);

  void setCustomPrompt(String? prompt) =>
      state = state.copyWith(customPrompt: prompt);

  void setResult(String path) =>
      state = state.copyWith(resultImagePath: path);

  void setCategory(String category) =>
      state = state.copyWith(designCategory: category);

  // ── Generation lifecycle ───────────────────────────────────────────────

  void startGeneration(DesignRepository repository) {
    if (!state.canGenerate) return;

    // Reset generation state
    state = state.copyWith(
      generationStage: GenerationStage.analyzing,
      generationProgress: 0.0,
      clearError: true,
      canRetry: false,
    );

    // Cancel any previous subscription
    _generationSub?.cancel();

    final stream = repository.createDesignWithProgress(
      imagePath: state.imagePath!,
      style: state.selectedStyle!,
      roomType: state.selectedRoomType!,
      customPrompt: state.customPrompt,
      isGarden: state.designCategory == 'garden',
    );

    _generationSub = stream.listen(
      (progress) {
        if (!mounted) return;

        state = state.copyWith(
          generationStage: progress.stage,
          generationProgress: progress.progress,
          errorMessage: progress.errorMessage,
          canRetry: progress.canRetry,
        );

        // When complete, grab result data from repository
        if (progress.stage == GenerationStage.complete) {
          final result = repository.lastResult;
          if (result != null) {
            state = state.copyWith(
              designId: result.id,
              originalImagePath: result.originalImagePath,
              generatedImagePath: result.generatedImagePath,
            );
          }
        }
      },
      onError: (error) {
        if (!mounted) return;
        state = state.copyWith(
          generationStage: GenerationStage.error,
          errorMessage: error.toString(),
          canRetry: true,
        );
      },
    );
  }

  void cancelGeneration(DesignRepository repository) {
    _generationSub?.cancel();
    _generationSub = null;
    repository.cancelGeneration();
    state = state.copyWith(
      generationStage: GenerationStage.idle,
      generationProgress: 0.0,
      clearError: true,
    );
  }

  void retryGeneration(DesignRepository repository) {
    cancelGeneration(repository);
    startGeneration(repository);
  }

  void clearResult() {
    state = state.copyWith(
      generationStage: GenerationStage.idle,
      generationProgress: 0.0,
      clearError: true,
    );
  }

  /// Load a saved DesignResult into the flow state (for gallery → result navigation)
  void loadFromDesignResult(DesignResult result) {
    state = DesignFlowState(
      designId: result.id,
      originalImagePath: result.originalImagePath,
      generatedImagePath: result.generatedImagePath,
      resultImagePath: result.generatedImagePath,
      generationStage: GenerationStage.complete,
      generationProgress: 1.0,
    );
  }

  void reset() {
    _generationSub?.cancel();
    _generationSub = null;
    state = const DesignFlowState();
  }

  @override
  void dispose() {
    _generationSub?.cancel();
    super.dispose();
  }
}

final designFlowProvider =
    StateNotifierProvider<DesignFlowNotifier, DesignFlowState>((ref) {
  return DesignFlowNotifier();
});
