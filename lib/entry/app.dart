import 'package:app_front/core/core.dart';
import 'package:app_front/core/widgets/errors/overlay.dart';
import 'package:app_front/entry/app_provider.dart';
import 'package:app_front/entry/entry.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/settings/settings.dart';
import 'package:flutter/material.dart';
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
            child: const _MaterialAppCore(),
          );
  }
}

class _MaterialAppCore extends StatelessWidget {
  const _MaterialAppCore();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();


       return MaterialApp.router(
          routerConfig: AppRouter.createRouter(auth, app),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
    );
  }
}
