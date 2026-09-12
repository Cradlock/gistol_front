import 'package:app_front/core/core.dart';
import 'package:app_front/core/widgets/errors/overlay.dart';
import 'package:app_front/entry/app_provider.dart';
import 'package:app_front/entry/entry.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class MainApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final AuthProvider authProvider;
  final AppProvider appProvider;
  
  const MainApp({
    super.key,
    required this.settingsProvider,
    required this.authProvider,
    required this.appProvider
  });

  @override
  Widget build(BuildContext context) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AppProvider>.value(value: appProvider),
              ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            // Передаем управление в ядро приложения
            child: const MyApp(),
          );
  }
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();

    _router = AppRouter.createRouter(authProvider, appProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Подписываемся на изменения SettingsProvider для реактивной смены темы
    final settingsProvider = context.watch<SettingsProvider>();

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,

      // Подключение темы
      themeMode: settingsProvider.themeMode,
      theme: ThemeData.light(useMaterial3: true), // Ваша светлая тема
      darkTheme: ThemeData.dark(useMaterial3: true), // Ваша тёмная тема

      // Локализация
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
