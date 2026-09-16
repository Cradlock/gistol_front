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

class AuthRedirect {
  final String? path;
  final bool warnNotConfirmed;

  const AuthRedirect(this.path, {this.warnNotConfirmed = false});
}

const _publicRoutes = {'/service', '/policy'};
const _unconfirmedAllowedRoutes = {'/profile', '/settings'};

AuthRedirect resolveAuthRedirect({
  required bool isLoading,
  required bool isLoggedIn,
  required bool isProfileComplete,
  required bool isConfirmed,
  required String location,
}) {
  if (isLoading) return const AuthRedirect(null);

  final isLoggingIn = location == '/login';
  final isCompletingProfile = location == '/complete';
  final isPublicRoute = _publicRoutes.contains(location);

  if (!isLoggedIn) {
    if (!isLoggingIn && !isPublicRoute) {
      return const AuthRedirect('/login');
    }
    return const AuthRedirect(null);
  }

  if (!isProfileComplete) {
    if (!isCompletingProfile) {
      return const AuthRedirect('/complete');
    }
    return const AuthRedirect(null);
  }

  if (!isConfirmed) {
    if (isPublicRoute) {
      return const AuthRedirect(null);
    }
    if (isLoggingIn ||
        isCompletingProfile ||
        location == '/' ||
        location == '/home' ||
        !_unconfirmedAllowedRoutes.contains(location)) {
      return const AuthRedirect('/profile', warnNotConfirmed: true);
    }
    return const AuthRedirect(null);
  }

  if (isLoggingIn ||
      isCompletingProfile ||
      location == '/' ||
      location == '/home') {
    return const AuthRedirect('/profile');
  }

  return const AuthRedirect(null);
}

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
        final result = resolveAuthRedirect(
          isLoading: authProvider.isLoading,
          isLoggedIn: authProvider.isLogged,
          isProfileComplete: authProvider.isComplete(),
          isConfirmed: authProvider.isConfirmed,
          location: state.matchedLocation,
        );

        if (result.warnNotConfirmed) {
          authProvider.warnNotConfirmed();
        }

        return result.path;
      },
    );
  }
}
