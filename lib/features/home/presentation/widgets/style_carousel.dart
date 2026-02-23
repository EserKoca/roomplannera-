import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/features/design/data/models/design_style.dart';

class StyleCarousel extends StatelessWidget {
  const StyleCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = DesignStyle.allStyles;

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];

          return GestureDetector(
            onTap: () => context.push(RoutePaths.styleSelection),
            child: Container(
              width: 128,
              margin: EdgeInsets.only(
                left: index == 0 ? AppSpacing.lg : 0,
                right: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient - brighter
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: style.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),

                    // Subtle center icon
                    Center(
                      child: Icon(
                        Icons.palette_rounded,
                        size: 36,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),

                    // Bottom gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.55),
                            ],
                            stops: const [0.45, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Style name
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        style.nameTr,
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // PRO badge - vibrant
                    if (style.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.premiumGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'PRO',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
