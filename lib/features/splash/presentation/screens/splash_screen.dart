import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final settingsBox = Hive.box('settings');
    final hasSeenOnboarding =
        settingsBox.get('hasSeenOnboarding', defaultValue: false) as bool;

    if (hasSeenOnboarding) {
      GoRouter.of(context).go(RoutePaths.home);
    } else {
      GoRouter.of(context).go(RoutePaths.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          // Warm colorful radial glow behind logo
          Center(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    AppColors.accent.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.6, 0.6),
                end: const Offset(1.0, 1.0),
                duration: 1500.ms,
                curve: Curves.easeOutCubic,
              ),

          // Second decorative orb
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.energyYellow.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 1500.ms, delay: 400.ms),

          // Logo content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App icon - colorful gradient
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: AppColors.premiumGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 28),

                // App name
                Text(
                  'RoomAI',
                  style: AppTypography.h1.copyWith(
                    fontSize: 42,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 10),

                // Tagline
                Text(
                  'Design Your Dream Space',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 2,
                    fontSize: 13,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
