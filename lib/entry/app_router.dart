

import 'package:app_front/entry/app_provider.dart';
import 'package:app_front/entry/screens/home_screen.dart';
import 'package:app_front/entry/screens/layout.dart';
import 'package:app_front/entry/screens/no_internet_screen.dart';
import 'package:app_front/entry/screens/splash_screen.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/screens/complete_profile_screen.dart';
import 'package:app_front/features/auth/screens/login_screen.dart';
import 'package:app_front/features/legal/screens/policy_screen.dart';
import 'package:app_front/features/legal/screens/service_screen.dart';
import 'package:app_front/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  // Глобальный ключ навигации
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static GoRouter createRouter( 
    AuthProvider authProvider,
    AppProvider appProvider
  ) { 
    return GoRouter(
    navigatorKey: navigatorKey, // Передаем ключ сюда
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: authProvider,
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      ShellRoute(
        builder: (context, state, child) => Mainlayout(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen())
        ]
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/service', builder: (context, state) => const ServiceScreen()),
      GoRoute(path: '/policy', builder: (context, state) => const PolicyScreen()),
      GoRoute(path: '/complete', builder: (context,state) => const CompleteProfileScreen())
    ],
  redirect: (BuildContext context, GoRouterState state) {
  final isLoading = authProvider.isLoading;
  final isLoggedIn = authProvider.isLogged;
  final isProfileComplete = authProvider.isComplete();
  
  final currentLocation = state.matchedLocation;
  
  // 1. Пока идет асинхронная проверка — не дергаем навигацию
  if (isLoading) return null;

  // Белый список публичных путей и путь экрана авторизации
  final isLoggingIn = currentLocation == '/login';
  final isCompletingProfile = currentLocation == '/complete'; // Убедитесь, что путь точно совпадает с GoRoute(path: '/complete')
  final isPublicRoute = currentLocation == '/service' || currentLocation == '/policy';

  // 2. НЕ авторизован -> только на /login
  if (!isLoggedIn) {
    if (!isLoggingIn && !isPublicRoute) {
      return '/login';
    }
    return null;
  }

  // 3. Авторизован, НО профиль НЕ заполнен -> только на /complete
  if (!isProfileComplete) {
    if (!isCompletingProfile) {
      return '/complete';
    }
    return null; // Уже на /complete — останавливаем редирект!
  }
  
  if (isLoggingIn || isCompletingProfile || currentLocation == '/') {
    return '/home';
  }

  return null;
  }
  );
  }

}
