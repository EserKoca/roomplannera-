import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:room_ai/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/glass_card.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';
import 'package:room_ai/features/design/providers/design_provider.dart';

class PhotoUploadScreen extends ConsumerStatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  String? _imagePath;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      ref.read(designFlowProvider.notifier).setImage(pickedFile.path);
    }
  }

  void _showPickerBottomSheet() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primary,
                ),
                title: Text(l10n.camera, style: AppTypography.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary,
                ),
                title: Text(l10n.fromGallery, style: AppTypography.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designState = ref.watch(designFlowProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.uploadPhoto, style: AppTypography.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Selected style & room type chips ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (designState.selectedStyle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        designState.selectedStyle!.name,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.primaryLight),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  if (designState.selectedRoomType != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        designState.selectedRoomType!.name,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.primaryLight),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            // ── Upload area ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.sm),

                    // Upload container / Image preview
                    GestureDetector(
                      onTap: _imagePath == null ? _showPickerBottomSheet : null,
                      child: _imagePath == null
                          ? _buildUploadPlaceholder(l10n)
                          : _buildImagePreview(),
                    ).animate().fadeIn(duration: 500.ms).scale(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1, 1),
                          duration: 500.ms,
                        ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Camera / Gallery buttons ─────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickImage(ImageSource.camera),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                                horizontal: AppSpacing.md,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    l10n.camera,
                                    style: AppTypography.labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickImage(ImageSource.gallery),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                                horizontal: AppSpacing.md,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.photo_library_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    l10n.fromGallery,
                                    style: AppTypography.labelLarge,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Tips section ─────────────────────────────────
                    _buildTipsSection(l10n)
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),

            // ── Continue button ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: GradientButton(
                text: l10n.continueButton,
                onPressed: _imagePath != null
                    ? () => context.push(RoutePaths.customPrompt)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder(AppLocalizations l10n) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.surfaceBorder,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload_rounded,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.tapToUpload,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Image.file(
            File(_imagePath!),
            height: 280,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: AppSpacing.sm,
          right: AppSpacing.sm,
          child: GestureDetector(
            onTap: _showPickerBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    AppLocalizations.of(context)!.changePhoto,
                    style: AppTypography.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection(AppLocalizations l10n) {
    final List<String> tips = [
      l10n.tip1,
      l10n.tip2,
      l10n.tip3,
      l10n.tip4,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.tipsTitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      tip,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
