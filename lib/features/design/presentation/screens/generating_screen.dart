import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/network/api_exceptions.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/glass_card.dart';
import 'package:room_ai/features/design/data/repositories/design_repository.dart';
import 'package:room_ai/features/design/providers/design_provider.dart';

class GeneratingScreen extends ConsumerStatefulWidget {
  const GeneratingScreen({super.key});

  @override
  ConsumerState<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends ConsumerState<GeneratingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;

  Timer? _tipTimer;
  int _currentTipIndex = 0;
  bool _hasNavigated = false;

  static const List<String> _designTips = [
    'The 60-30-10 rule: 60% dominant, 30% secondary, 10% accent',
    'Adding plants can increase perceived room value',
    'Natural light creates the most welcoming atmosphere',
    'Mirrors opposite windows make rooms feel larger',
    'Layered lighting creates depth and warmth in any room',
    'Odd numbers of decorative items create visual interest',
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Rotate tips every 5 seconds
    _tipTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _designTips.length;
        });
      }
    });

    // Start real generation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGeneration();
    });
  }

  void _startGeneration() {
    final repository = ref.read(designRepositoryProvider);
    ref.read(designFlowProvider.notifier).startGeneration(repository);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _tipTimer?.cancel();
    super.dispose();
  }

  String _getStatusMessage(AppLocalizations l10n, GenerationStage stage) {
    final designState = ref.read(designFlowProvider);
    final styleName = designState.selectedStyle?.name ?? '';

    switch (stage) {
      case GenerationStage.idle:
        return l10n.analyzingRoom;
      case GenerationStage.analyzing:
        return l10n.analyzingRoom;
      case GenerationStage.generating:
        return l10n.applyingStyle(styleName);
      case GenerationStage.downloading:
        return l10n.refiningDetails;
      case GenerationStage.saving:
        return l10n.addingTouches;
      case GenerationStage.complete:
        return l10n.almostReady;
      case GenerationStage.error:
        return designState.errorMessage ?? 'Something went wrong';
    }
  }

  void _showErrorDialog(String message, bool canRetry) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text('Generation Failed', style: AppTypography.h3),
          ],
        ),
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (context.mounted) context.go(RoutePaths.home);
            },
            child: Text(
              'Go Back',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (canRetry)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                final repository = ref.read(designRepositoryProvider);
                ref.read(designFlowProvider.notifier).retryGeneration(repository);
              },
              child: Text(
                'Retry',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designState = ref.watch(designFlowProvider);
    final stage = designState.generationStage;
    final progress = designState.generationProgress;
    final percentage = (progress * 100).toInt();

    // Listen for completion or error
    ref.listen<DesignFlowState>(designFlowProvider, (previous, next) {
      if (!mounted || _hasNavigated) return;

      if (next.isComplete && next.generatedImagePath != null) {
        _hasNavigated = true;
        context.go(RoutePaths.result);
      } else if (next.hasError) {
        _showErrorDialog(
          next.errorMessage ?? 'Something went wrong. Please try again.',
          next.canRetry,
        );
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.bgSecondary,
            title: Text(l10n.cancel, style: AppTypography.h3),
            content: Text(
              l10n.cancelGeneration,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  l10n.continueButton,
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.primary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  l10n.cancel,
                  style: AppTypography.labelLarge
                      .copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        );

        if (shouldLeave == true && context.mounted) {
          final repository = ref.read(designRepositoryProvider);
          ref.read(designFlowProvider.notifier).cancelGeneration(repository);
          context.go(RoutePaths.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // ── Animated sparkle icon ────────────────────────────
                const Icon(
                  Icons.auto_awesome,
                  size: 80,
                  color: AppColors.primary,
                )
                    .animate(onPlay: (c) => c.repeat())
                    .rotate(duration: 2.seconds)
                    .shimmer(
                      duration: 2.seconds,
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                    ),

                const SizedBox(height: AppSpacing.xl),

                // ── Progress bar ─────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 6,
                    width: 240,
                    child: Stack(
                      children: [
                        // Background track
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.warmGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Animated progress fill
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.premiumGradient
                                    .createShader(bounds),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ── Percentage text ──────────────────────────────────
                Text(
                  '$percentage%',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // ── Status message with animated switcher ────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    _getStatusMessage(l10n, stage),
                    key: ValueKey(stage),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── "Usually takes" text ─────────────────────────────
                Text(
                  l10n.usuallyTakes,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Rotating design tip card ─────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: Row(
                        key: ValueKey(_currentTipIndex),
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: AppColors.energyYellow,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _designTips[_currentTipIndex],
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated fractionally sized box ──────────────────────────────────────────
class AnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  final double widthFactor;
  final Widget child;

  const AnimatedFractionallySizedBox({
    super.key,
    required this.widthFactor,
    required this.child,
    required super.duration,
    super.curve,
  });

  @override
  AnimatedWidgetBaseState<AnimatedFractionallySizedBox> createState() =>
      _AnimatedFractionallySizedBoxState();
}

class _AnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AnimatedFractionallySizedBox> {
  Tween<double>? _widthFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _widthFactor = visitor(
      _widthFactor,
      widget.widthFactor,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: _widthFactor?.evaluate(animation) ?? widget.widthFactor,
      child: widget.child,
    );
  }
}
