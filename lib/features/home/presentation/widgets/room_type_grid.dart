import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/features/design/data/models/room_type.dart';

class RoomTypeGrid extends StatelessWidget {
  const RoomTypeGrid({super.key});

  // Map room type IDs to warm, relevant colors
  static const Map<String, Color> _roomColors = {
    'living_room': AppColors.primary,
    'bedroom': Color(0xFFB08DAB),
    'kitchen': Color(0xFFE8A87C),
    'bathroom': Color(0xFF7EC8C8),
    'garden': AppColors.accent,
    'office': Color(0xFF9BA4B4),
    'kids_room': Color(0xFFE8C067),
    'dining_room': Color(0xFFD4845A),
  };

  @override
  Widget build(BuildContext context) {
    final roomTypes = RoomType.allTypes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: roomTypes.length,
        itemBuilder: (context, index) {
          final roomType = roomTypes[index];
          final color = _roomColors[roomType.id] ?? AppColors.primary;

          return GestureDetector(
            onTap: () => context.push(RoutePaths.styleSelection),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceGlass,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.surfaceBorder,
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        roomType.icon,
                        size: 20,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    roomType.nameTr,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: Duration(milliseconds: index * 40))
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }
}
