import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: GestureDetector(
        onTap: () => context.push(RoutePaths.paywall),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A2118), Color(0xFF1E1815)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unlock All Styles',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Unlimited designs & premium features',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
