import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:room_ai/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/glass_card.dart';
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
        child: CustomScrollView(
          slivers: [
            // ── 1. Header ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.premiumGradient.createShader(bounds),
                      child: Text(
                        l10n.appName,
                        style:
                            AppTypography.h2.copyWith(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.push(RoutePaths.paywall),
                      icon: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.goldGradient.createShader(bounds),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 0))
                  .slideY(begin: 0.05),
            ),

            // ── 2. Greeting ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.greeting, style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      remaining < 0
                          ? 'Unlimited designs (Pro)'
                          : l10n.designsRemaining(remaining),
                      style: AppTypography.bodySmall.copyWith(
                        color: remaining == 0
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 100))
                  .slideY(begin: 0.05),
            ),

            // ── 3. Quick Actions ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => startDesignFlow('room'),
                        child: SizedBox(
                          height: 140,
                          child: GlassCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.weekend_rounded,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(l10n.roomDesign,
                                    style: AppTypography.labelLarge),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  l10n.roomDesignDesc,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => startDesignFlow('garden'),
                        child: SizedBox(
                          height: 140,
                          child: GlassCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.yard_rounded,
                                  size: 40,
                                  color: Color(0xFF00b894),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(l10n.gardenDesign,
                                    style: AppTypography.labelLarge),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  l10n.gardenDesignDesc,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 200))
                  .slideY(begin: 0.05),
            ),

            // ── 4. Design Styles header ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 300))
                  .slideY(begin: 0.05),
            ),

            // ── 5. Style Carousel ──────────────────────────────────────
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: StyleCarousel(),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 400))
                  .slideY(begin: 0.05),
            ),

            // ── 6. Room Types header ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Text(l10n.roomTypes, style: AppTypography.h3),
              )
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 500))
                  .slideY(begin: 0.05),
            ),

            // ── 7. Room Type Grid ──────────────────────────────────────
            SliverToBoxAdapter(
              child: const RoomTypeGrid()
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 600))
                  .slideY(begin: 0.05),
            ),

            // ── 8. Premium Banner ──────────────────────────────────────
            SliverToBoxAdapter(
              child: const PremiumBanner()
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 700))
                  .slideY(begin: 0.05),
            ),

            // ── 9. Bottom padding for nav bar ──────────────────────────
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
