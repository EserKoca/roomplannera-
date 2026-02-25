import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:room_ai/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/design_style.dart';
import '../../providers/design_provider.dart';

class StyleSelectionScreen extends ConsumerStatefulWidget {
  const StyleSelectionScreen({super.key});

  @override
  ConsumerState<StyleSelectionScreen> createState() =>
      _StyleSelectionScreenState();
}

class _StyleSelectionScreenState extends ConsumerState<StyleSelectionScreen> {
  String? _selectedStyleId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designFlow = ref.watch(designFlowProvider);
    final styles = DesignStyle.allStyles;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.selectStyle, style: AppTypography.h3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category chip
          if (designFlow.designCategory != null)
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGradient,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    designFlow.designCategory == 'room'
                        ? l10n.roomDesign
                        : l10n.gardenDesign,
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Grid of styles
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: styles.length,
              itemBuilder: (context, index) {
                final style = styles[index];
                final isSelected = _selectedStyleId == style.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStyleId = style.id;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                      border: isSelected
                          ? Border.all(
                              color: AppColors.primary,
                              width: 3,
                            )
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusLg),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Gradient background
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: style.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),

                          // Center icon
                          Center(
                            child: Icon(
                              Icons.palette_rounded,
                              size: 48,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),

                          // Bottom gradient overlay
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Style name
                          Positioned(
                            left: 12,
                            bottom: 12,
                            right: 12,
                            child: Text(
                              style.nameTr,
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Selected checkmark
                          if (isSelected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(
                      duration: 400.ms,
                      delay: (50 * index).ms,
                    )
                    .slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 400.ms,
                      delay: (50 * index).ms,
                      curve: Curves.easeOut,
                    );
              },
            ),
          ),

          // Continue button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: GradientButton(
                text: l10n.continueButton,
                onPressed: _selectedStyleId != null
                    ? () {
                        final selectedStyle = styles.firstWhere(
                          (s) => s.id == _selectedStyleId,
                        );
                        ref
                            .read(designFlowProvider.notifier)
                            .selectStyle(selectedStyle);
                        context.push(RoutePaths.roomType);
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
