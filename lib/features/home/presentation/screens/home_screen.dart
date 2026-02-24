import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/features/design/data/repositories/design_repository.dart';
import 'package:room_ai/features/design/providers/design_provider.dart';
import 'package:room_ai/features/home/presentation/widgets/premium_banner.dart';
import 'package:room_ai/features/home/presentation/widgets/room_type_grid.dart';
import 'package:room_ai/features/home/presentation/widgets/style_carousel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repository = ref.watch(designRepositoryProvider);
    final remaining = repository.getRemainingDesigns();
    final canGenerate = repository.canGenerateDesign();

    void startDesignFlow(String category) {
      if (!canGenerate) {
        context.push(RoutePaths.paywall);
        return;
      }
      ref.read(designFlowProvider.notifier).reset();
      ref.read(designFlowProvider.notifier).setCategory(category);
      context.push(RoutePaths.styleSelection);
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // ── 1. Header ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
                child: Row(
                  children: [
                    // App logo + name
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: AppColors.premiumGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.appName,
                          style: AppTypography.h3.copyWith(
                            letterSpacing: -0.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Pro badge with gradient
                    GestureDetector(
                      onTap: () => context.push(RoutePaths.paywall),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumGradient,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.workspace_premium_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PRO',
                              style: AppTypography.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.03),
            ),

            // ── 2. Greeting + Remaining ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.greeting,
                      style: AppTypography.h1.copyWith(
                        fontSize: 28,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          remaining < 0
                              ? (repository.isDemoMode
                                  ? 'Demo mode • Unlimited designs'
                                  : 'Unlimited designs')
                              : l10n.designsRemaining(remaining),
                          style: AppTypography.bodySmall.copyWith(
                            color: remaining == 0
                                ? AppColors.error
                                : AppColors.textTertiary,
                          ),
                        ),
                        if (repository.isDemoMode) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.energyYellow.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              'DEMO',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.energyYellow,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 80.ms)
                  .slideY(begin: 0.03),
            ),

            // ── 3. Quick Actions ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.weekend_rounded,
                        iconColor: AppColors.primary,
                        bgColor: AppColors.primary.withValues(alpha: 0.1),
                        title: l10n.roomDesign,
                        subtitle: l10n.roomDesignDesc,
                        onTap: () => startDesignFlow('room'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.yard_rounded,
                        iconColor: AppColors.accent,
                        bgColor: AppColors.accent.withValues(alpha: 0.1),
                        title: l10n.gardenDesign,
                        subtitle: l10n.gardenDesignDesc,
                        onTap: () => startDesignFlow('garden'),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 160.ms)
                  .slideY(begin: 0.03),
            ),

            // ── 4. Design Styles header ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.designStyles, style: AppTypography.h3),
                    GestureDetector(
                      onTap: () => context.push(RoutePaths.styleSelection),
                      child: Text(
                        l10n.seeAll,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 240.ms),
            ),

            // ── 5. Style Carousel ────────────────────────────────────
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: StyleCarousel(),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 320.ms),
            ),

            // ── 6. Room Types header ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.md),
                child: Text(l10n.roomTypes, style: AppTypography.h3),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 400.ms),
            ),

            // ── 7. Room Type Grid ────────────────────────────────────
            SliverToBoxAdapter(
              child: const RoomTypeGrid()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 480.ms),
            ),

            // ── 8. Premium Banner ────────────────────────────────────
            SliverToBoxAdapter(
              child: const PremiumBanner()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 560.ms),
            ),

            // ── 9. Bottom padding for liquid glass nav bar ───────────
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quick action card widget ─────────────────────────────────────────────────

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: AppColors.warmGray.withValues(alpha: 0.4),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(icon, size: 24, color: iconColor),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLarge),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
