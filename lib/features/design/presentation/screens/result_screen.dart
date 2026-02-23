import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/before_after_slider.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';
import 'package:room_ai/features/design/data/repositories/design_repository.dart';
import 'package:room_ai/features/design/providers/design_provider.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoriteState();
    });
  }

  void _loadFavoriteState() {
    final designState = ref.read(designFlowProvider);
    final designId = designState.designId;
    if (designId != null) {
      final repository = ref.read(designRepositoryProvider);
      final design = repository.getDesignById(designId);
      if (design != null && mounted) {
        setState(() => _isFavorite = design.isFavorite);
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final designState = ref.read(designFlowProvider);
    final designId = designState.designId;
    if (designId == null) return;

    final repository = ref.read(designRepositoryProvider);
    await repository.toggleFavorite(designId);
    if (mounted) {
      setState(() => _isFavorite = !_isFavorite);
    }
  }

  Future<void> _saveImage() async {
    final designState = ref.read(designFlowProvider);
    final generatedPath = designState.generatedImagePath;
    if (generatedPath == null) return;

    try {
      await Share.shareXFiles(
        [XFile(generatedPath)],
        text: 'Room design created with RoomAI',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _shareImage() async {
    final designState = ref.read(designFlowProvider);
    final generatedPath = designState.generatedImagePath;
    if (generatedPath == null) return;

    try {
      await Share.shareXFiles(
        [XFile(generatedPath)],
        text: 'Check out this room design I created with RoomAI!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _regenerate() {
    ref.read(designFlowProvider.notifier).clearResult();
    context.go(RoutePaths.generating);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designState = ref.watch(designFlowProvider);

    final styleName = designState.selectedStyle?.name ?? '';
    final roomTypeName = designState.selectedRoomType?.name ?? '';

    final originalPath = designState.originalImagePath ?? designState.imagePath;
    final generatedPath = designState.generatedImagePath;

    final hasOriginal = originalPath != null && File(originalPath).existsSync();
    final hasGenerated = generatedPath != null && File(generatedPath).existsSync();

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go(RoutePaths.home),
        ),
        title: Text(l10n.yourDesign, style: AppTypography.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Design result display ────────────────────────────────
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.md),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: hasOriginal && hasGenerated
                    ? BeforeAfterSlider(
                        beforeImage: FileImage(File(originalPath)),
                        afterImage: FileImage(File(generatedPath)),
                      )
                    : hasGenerated
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusLg),
                            child: Image.file(
                              File(generatedPath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : _buildPlaceholder(),
              )
                  .animate()
                  .fadeIn(duration: 800.ms),
            ),

            // ── Bottom action panel ──────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgSecondary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Style and room type chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (styleName.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull),
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            styleName,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      if (roomTypeName.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull),
                            border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            roomTypeName,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── 4 Action buttons ───────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: _isFavorite ? AppColors.error : null,
                        label: l10n.favorite,
                        onTap: _toggleFavorite,
                      ),
                      _ActionButton(
                        icon: Icons.download_rounded,
                        label: l10n.save,
                        onTap: _saveImage,
                      ),
                      _ActionButton(
                        icon: Icons.share_rounded,
                        label: l10n.share,
                        onTap: _shareImage,
                      ),
                      _ActionButton(
                        icon: Icons.refresh_rounded,
                        label: l10n.regenerate,
                        onTap: _regenerate,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Create new design button ───────────────────────
                  GradientButton(
                    text: 'Create New Design',
                    onPressed: () {
                      ref.read(designFlowProvider.notifier).reset();
                      context.go(RoutePaths.home);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final designState = ref.read(designFlowProvider);
    final gradientColors = designState.selectedStyle?.gradientColors ??
        [AppColors.primary, AppColors.primaryLight];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: LinearGradient(
          colors: [
            gradientColors.first.withValues(alpha: 0.3),
            gradientColors.last.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppLocalizations.of(context)!.designReady,
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your room has been transformed',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private action button widget ─────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: AppColors.warmGray.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.textPrimary,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
