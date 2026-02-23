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
          // Subtle warm radial glow behind logo
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primary.withValues(alpha: 0.02),
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

          // Logo content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AppColors.premiumGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 36,
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

                const SizedBox(height: 24),

                // App name
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.premiumGradient.createShader(bounds),
                  child: Text(
                    'RoomAI',
                    style: AppTypography.h1.copyWith(
                      fontSize: 40,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
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

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Design Your Space',
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
