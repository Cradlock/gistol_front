
import 'package:app_front/entry/app_provider.dart';
import 'package:app_front/entry/screens/layout.dart';
import 'package:app_front/entry/screens/splash_screen.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/screens/complete_profile_screen.dart';
import 'package:app_front/features/exams/exams.dart';
import 'package:app_front/features/legal/screens/policy_screen.dart';
import 'package:app_front/features/legal/screens/service_screen.dart';
import 'package:app_front/features/profile/profile.dart';
import 'package:app_front/features/settings/screens/settings_screen.dart';
import 'package:app_front/features/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(
    AuthProvider authProvider,
    AppProvider appProvider,
  ) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: authProvider,
      routes: [
        GoRoute(path: '/', builder: (context, state) => SplashScreen()),
        ShellRoute(
          builder: (context, state, child) => Mainlayout(child: child),
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
            GoRoute(path: '/tasks', builder: (context, state) => const TasksScreen()),
            GoRoute(path: '/exams', builder: (context, state) => const ExamsScreen()),
            GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
          ],
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/service', builder: (context, state) => const ServiceScreen()),
        GoRoute(path: '/policy', builder: (context, state) => const PolicyScreen()),
        GoRoute(path: '/complete', builder: (context, state) => const CompleteProfileScreen()),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final isLoading = authProvider.isLoading;
        final isLoggedIn = authProvider.isLogged;
        final isProfileComplete = authProvider.isComplete();
        final currentLocation = state.matchedLocation;

        if (isLoading) return null;

        final isLoggingIn = currentLocation == '/login';
        final isCompletingProfile = currentLocation == '/complete';
        final isPublicRoute =
            currentLocation == '/service' || currentLocation == '/policy';

        if (!isLoggedIn) {
          if (!isLoggingIn && !isPublicRoute) {
            return '/login';
          }
          return null;
        }

        if (!isProfileComplete) {
          if (!isCompletingProfile) {
            return '/complete';
          }
          return null;
        }

        if (isLoggingIn ||
            isCompletingProfile ||
            currentLocation == '/' ||
            currentLocation == '/home') {
          return '/profile';
        }

        return null;
      },
    );
  }
}
