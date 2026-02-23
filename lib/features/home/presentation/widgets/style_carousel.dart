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
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: styles.length,
        itemBuilder: (context, index) {
          final style = styles[index];

          return GestureDetector(
            onTap: () => context.push(RoutePaths.styleSelection),
            child: Container(
              width: 130,
              margin: EdgeInsets.only(
                left: index == 0 ? AppSpacing.md : 0,
                right: 12,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient
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
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.3),
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
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.4, 1.0],
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
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // PRO badge
                    if (style.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldGradient,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                          child: Text(
                            'PRO',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
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
