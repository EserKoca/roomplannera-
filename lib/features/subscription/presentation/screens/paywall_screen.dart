import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selectedPlan = 'annual';

  static const List<String> _features = [
    'Unlimited room designs',
    'All 20+ premium styles',
    'HD quality exports',
    'No watermarks',
    'Custom prompts & garden design',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xxl),

                  // Premium icon
                  const Icon(
                    Icons.workspace_premium_rounded,
                    size: 80,
                    color: AppColors.accent,
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .shimmer(
                        duration: 1800.ms,
                        delay: 400.ms,
                        color: AppColors.accentDark.withValues(alpha: 0.4),
                      ),

                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  Text(
                    'Unlock Unlimited Designs',
                    style: AppTypography.h1,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Feature list
                  ...List.generate(_features.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              _features[index],
                              style: AppTypography.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 400.ms,
                          delay: (200 + index * 100).ms,
                        )
                        .slideX(
                          begin: -0.1,
                          end: 0,
                          duration: 400.ms,
                          delay: (200 + index * 100).ms,
                          curve: Curves.easeOut,
                        );
                  }),

                  const SizedBox(height: AppSpacing.xl),

                  // Plan cards
                  Row(
                    children: [
                      // Monthly plan
                      Expanded(
                        child: _PlanCard(
                          title: 'Monthly',
                          price: '\$4.99',
                          period: '/month',
                          isSelected: _selectedPlan == 'monthly',
                          onTap: () => setState(() => _selectedPlan = 'monthly'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Annual plan
                      Expanded(
                        child: _PlanCard(
                          title: 'Annual',
                          price: '\$29.99',
                          period: '/year',
                          isSelected: _selectedPlan == 'annual',
                          badgeText: 'SAVE 50%',
                          subtitleText: '3-day free trial',
                          onTap: () => setState(() => _selectedPlan = 'annual'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // CTA Button
                  GradientButton(
                    text: 'Start Free Trial',
                    gradient: AppColors.goldGradient,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Subscription coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Cancel anytime
                  Text(
                    'Cancel anytime',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Restore Purchases
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Restore purchases coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text(
                      'Restore Purchases',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Terms and Privacy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Terms of Service',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                      Text(
                        '|',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Privacy Policy',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),

            // Close button top-right (appears after 1.5s delay)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlass,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: 1500.ms,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final String? badgeText;
  final String? subtitleText;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    this.badgeText,
    this.subtitleText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Badge
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  badgeText!,
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Title
            Text(
              title,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // Price
            Text(price, style: AppTypography.h2),
            const SizedBox(height: 2),

            // Period
            Text(
              period,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),

            // Subtitle (e.g., "3-day free trial")
            if (subtitleText != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitleText!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
