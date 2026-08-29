

import 'package:app_front/entry/screens/home_screen.dart';
import 'package:app_front/entry/screens/layout.dart';
import 'package:app_front/entry/screens/no_internet_screen.dart';
import 'package:app_front/features/auth/screens/login_screen.dart';
import 'package:app_front/features/auth/screens/splash_screen.dart';
import 'package:app_front/features/legal/screens/policy_screen.dart';
import 'package:app_front/features/legal/screens/service_screen.dart';
import 'package:app_front/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // Глобальный ключ навигации
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey, // Передаем ключ сюда
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, child) => SplashScreen()),
      GoRoute(path: '/no-internet', builder: (context, child) => NoInternetScreen()),
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
    ],
  );
}
