

import 'package:app_front/entry/screens/home_screen.dart';
import 'package:app_front/entry/screens/layout.dart';
import 'package:app_front/entry/screens/no_internet_screen.dart';
import 'package:app_front/entry/screens/splash_screen.dart';
import 'package:app_front/features/auth/auth.dart';
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
    redirect: (context,state) async {
     final authProvider = context.read<AuthProvider>();
      
      // Допустим, мы еще не проверяли статус при старте
      // Здесь можно вызвать разовую проверку токенов из SharedPreferences / API
      // bool isLoggedIn = authProvider.isLogged;
      
      // Пример логики перенаправления:
      final isLoggingIn = state.uri.path == '/login';
      final isSplash = state.uri.path == '/';

      // Если пользователь на корне, отправляем его проверять статус или сразу на home/login
      if (isSplash) {
        // Здесь можно выполнить твой запрос checkLoginStatus()
        try {
          await authProvider.checkLoginStatus();
        } catch (_) {}

        return authProvider.isLogged ? '/home' : '/login';
      }

      // Если не залогинен и пытается зайти куда-то кроме логина
      if (!authProvider.isLogged && !isLoggingIn && state.uri.path != '/no-internet') {
        return '/login';
      }

      return null; // О

    }
  );
}
