import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/glass_card.dart';
import 'package:room_ai/features/design/data/models/room_type.dart';

class RoomTypeGrid extends StatelessWidget {
  const RoomTypeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final roomTypes = RoomType.allTypes;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.85,
        ),
        itemCount: roomTypes.length,
        itemBuilder: (context, index) {
          final roomType = roomTypes[index];

          return GestureDetector(
            onTap: () => context.push(RoutePaths.styleSelection),
            child: GlassCard(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    roomType.icon,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    roomType.nameTr,
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: Duration(milliseconds: index * 50))
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
        },
      ),
    );
  }
}
