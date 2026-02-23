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
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
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
        icon: Icons.auto_awesome,
        gradient: AppColors.premiumGradient,
        title: l10n.onboarding1Title,
        subtitle: l10n.onboarding1Subtitle,
      ),
      _OnboardingPageData(
        icon: Icons.camera_alt_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF00b894), Color(0xFF00cec9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: l10n.onboarding2Title,
        subtitle: l10n.onboarding2Subtitle,
      ),
      _OnboardingPageData(
        icon: Icons.bolt_rounded,
        gradient: AppColors.goldGradient,
        title: l10n.onboarding3Title,
        subtitle: l10n.onboarding3Subtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: pages[index]);
                },
              ),
            ),

            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.textTertiary,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Buttons
                  if (_currentPage < 2) ...[
                    GradientButton(
                      text: 'Next',
                      onPressed: _nextPage,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        'Skip',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ] else ...[
                    GradientButton(
                      text: 'Get Started',
                      onPressed: _completeOnboarding,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        '3 Free Designs',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data class for onboarding page content
// ---------------------------------------------------------------------------
class _OnboardingPageData {
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String subtitle;

  const _OnboardingPageData({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
  });
}

// ---------------------------------------------------------------------------
// Individual onboarding page widget
// ---------------------------------------------------------------------------
class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top gradient area (55% of the page)
        Expanded(
          flex: 55,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: data.gradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppSpacing.radiusXl),
                bottomRight: Radius.circular(AppSpacing.radiusXl),
              ),
            ),
            child: Center(
              child: Icon(
                data.icon,
                size: 120,
                color: Colors.white.withValues(alpha: 0.9),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  ),
            ),
          ),
        ),

        // Bottom text area (45% of the page)
        Expanded(
          flex: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  style: AppTypography.h1,
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),
                const SizedBox(height: AppSpacing.md),
                Text(
                  data.subtitle,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 400.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
