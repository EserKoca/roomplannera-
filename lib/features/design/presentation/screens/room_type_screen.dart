import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:room_ai/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/router/app_router.dart';
import '../../data/models/room_type.dart';
import '../../providers/design_provider.dart';

class RoomTypeScreen extends ConsumerStatefulWidget {
  const RoomTypeScreen({super.key});

  @override
  ConsumerState<RoomTypeScreen> createState() => _RoomTypeScreenState();
}

class _RoomTypeScreenState extends ConsumerState<RoomTypeScreen> {
  String? _selectedRoomTypeId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designFlow = ref.watch(designFlowProvider);
    final roomTypes = RoomType.allTypes;

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
        title: Text(l10n.selectRoomType, style: AppTypography.h3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Summary chip showing selected style
          if (designFlow.selectedStyle != null)
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
                    color: AppColors.surfaceGlass,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.palette_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        designFlow.selectedStyle!.nameTr,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Grid of room types
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: roomTypes.length,
              itemBuilder: (context, index) {
                final roomType = roomTypes[index];
                final isSelected = _selectedRoomTypeId == roomType.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRoomTypeId = roomType.id;
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
                              width: 2,
                            )
                          : null,
                    ),
                    child: GlassCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      borderRadius: AppSpacing.radiusLg,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            roomType.icon,
                            size: 40,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            roomType.nameTr,
                            style: AppTypography.labelLarge.copyWith(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                onPressed: _selectedRoomTypeId != null
                    ? () {
                        final selectedRoomType = roomTypes.firstWhere(
                          (rt) => rt.id == _selectedRoomTypeId,
                        );
                        ref
                            .read(designFlowProvider.notifier)
                            .selectRoomType(selectedRoomType);
                        context.push(RoutePaths.photoUpload);
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
