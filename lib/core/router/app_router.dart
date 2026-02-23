import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/scaffold_with_nav_bar.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/gallery/presentation/screens/gallery_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/design/presentation/screens/style_selection_screen.dart';
import '../../features/design/presentation/screens/room_type_screen.dart';
import '../../features/design/presentation/screens/photo_upload_screen.dart';
import '../../features/design/presentation/screens/custom_prompt_screen.dart';
import '../../features/design/presentation/screens/generating_screen.dart';
import '../../features/design/presentation/screens/result_screen.dart';
import '../../features/subscription/presentation/screens/paywall_screen.dart';

class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String gallery = '/gallery';
  static const String settings = '/settings';
  static const String styleSelection = '/style-selection';
  static const String roomType = '/room-type';
  static const String photoUpload = '/photo-upload';
  static const String customPrompt = '/custom-prompt';
  static const String generating = '/generating';
  static const String result = '/result';
  static const String paywall = '/paywall';
  static const String galleryDetail = '/gallery/detail';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _galleryNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'gallery');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final onboardingBox = Hive.box('settings');
      final hasSeenOnboarding =
          onboardingBox.get('hasSeenOnboarding', defaultValue: false) as bool;

      final isOnSplash = state.matchedLocation == RoutePaths.splash;
      if (isOnSplash) return null;
      if (!hasSeenOnboarding &&
          state.matchedLocation != RoutePaths.onboarding) {
        return RoutePaths.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.styleSelection,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StyleSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.roomType,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RoomTypeScreen(),
      ),
      GoRoute(
        path: RoutePaths.photoUpload,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PhotoUploadScreen(),
      ),
      GoRoute(
        path: RoutePaths.customPrompt,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CustomPromptScreen(),
      ),
      GoRoute(
        path: RoutePaths.generating,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GeneratingScreen(),
      ),
      GoRoute(
        path: RoutePaths.result,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: RoutePaths.paywall,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PaywallScreen(),
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(child: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _galleryNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.gallery,
                builder: (context, state) => const GalleryScreen(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) => const Scaffold(
                      body: Center(child: Text('GalleryDetailScreen')),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
