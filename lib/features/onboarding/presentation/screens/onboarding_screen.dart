import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:room_ai/l10n/app_localizations.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _completeOnboarding() {
    Hive.box('settings').put('hasSeenOnboarding', true);
    GoRouter.of(context).go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      _OnboardingPageData(
        icon: Icons.auto_awesome_rounded,
        accentColor: AppColors.primary,
        bgDecorationColor: AppColors.primary,
        secondaryColor: AppColors.energyYellow,
        title: l10n.onboarding1Title,
        subtitle: l10n.onboarding1Subtitle,
        featureItems: const ['Room Redesign', 'Garden Design', 'Custom AI Prompts'],
      ),
      _OnboardingPageData(
        icon: Icons.camera_enhance_rounded,
        accentColor: AppColors.accent,
        bgDecorationColor: AppColors.accent,
        secondaryColor: AppColors.skyBlue,
        title: l10n.onboarding2Title,
        subtitle: l10n.onboarding2Subtitle,
        featureItems: const ['Snap a Photo', 'Pick a Style', 'Get Results in Seconds'],
      ),
      _OnboardingPageData(
        icon: Icons.palette_rounded,
        accentColor: AppColors.lavender,
        bgDecorationColor: AppColors.lavender,
        secondaryColor: AppColors.softPink,
        title: l10n.onboarding3Title,
        subtitle: l10n.onboarding3Subtitle,
        featureItems: const ['15+ Design Styles', 'Before & After', 'Share Instantly'],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          // ── Page content ──────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _OnboardingPage(data: pages[index]);
            },
          ),

          // ── Bottom controls (overlaid) ────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    MediaQuery.of(context).padding.bottom + AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.bgPrimary.withValues(alpha: 0.0),
                        AppColors.bgPrimary.withValues(alpha: 0.9),
                        AppColors.bgPrimary,
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: pages.length,
                        effect: WormEffect(
                          activeDotColor: AppColors.primary,
                          dotColor: AppColors.warmGray,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Buttons
                      if (_currentPage < 2) ...[
                        GradientButton(
                          text: 'Next',
                          onPressed: _nextPage,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        GestureDetector(
                          onTap: _completeOnboarding,
                          child: Text(
                            'Skip',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ] else ...[
                        GradientButton(
                          text: 'Get Started',
                          onPressed: _completeOnboarding,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs + 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusFull),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '3 Free Designs Included',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.accent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data ─────────────────────────────────────────────────────────────────────

class _OnboardingPageData {
  final IconData icon;
  final Color accentColor;
  final Color bgDecorationColor;
  final Color secondaryColor;
  final String title;
  final String subtitle;
  final List<String> featureItems;

  const _OnboardingPageData({
    required this.icon,
    required this.accentColor,
    required this.bgDecorationColor,
    required this.secondaryColor,
    required this.title,
    required this.subtitle,
    required this.featureItems,
  });
}

// ── Page widget ──────────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // ── Background decorative orbs ───────────────────────────────
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.bgDecorationColor.withValues(alpha: 0.15),
                  data.bgDecorationColor.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 1000.ms)
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 1200.ms,
                curve: Curves.easeOutCubic,
              ),
        ),

        Positioned(
          bottom: screenSize.height * 0.3,
          left: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.secondaryColor.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 300.ms),
        ),

        // ── Content ─────────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.08),

                // Icon in a colorful circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.accentColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: data.accentColor.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: data.accentColor.withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      data.icon,
                      size: 52,
                      color: data.accentColor,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.easeOutBack,
                    ),

                SizedBox(height: screenSize.height * 0.06),

                // Title
                Text(
                  data.title,
                  style: AppTypography.h1.copyWith(
                    fontSize: 28,
                    height: 1.2,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: AppSpacing.md),

                // Subtitle
                Text(
                  data.subtitle,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 350.ms)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOutCubic,
                    ),

                SizedBox(height: screenSize.height * 0.05),

                // Feature chips - colorful pill buttons
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.center,
                  children: data.featureItems.asMap().entries.map((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: data.accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(
                          color: data.accentColor.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: data.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.value,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 400.ms,
                          delay: (500 + entry.key * 100).ms,
                        )
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 400.ms,
                          delay: (500 + entry.key * 100).ms,
                        );
                  }).toList(),
                ),

                // Extra bottom spacing for the overlay controls
                SizedBox(height: screenSize.height * 0.2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
