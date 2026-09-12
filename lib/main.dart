




import 'package:app_front/core/core.dart';
import 'package:app_front/entry/app_provider.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/settings/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:app_front/entry/entry.dart';

void main() async {

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  WidgetsFlutterBinding.ensureInitialized();
  

try {
  await dotenv.load(fileName: ".env");
} catch (e) {
  debugPrint('Warning: .env file not found or failed to load: $e');
}   

  final appProvider = AppProvider(); 
  final settingsProvider = SettingsProvider();
  final authProvider = AuthProvider();
  await EasyLocalization.ensureInitialized();

  await Future.wait([
    settingsProvider.initSettings(),
    appProvider.init()
  ]);

   
  final apiClient = ApiClient()..addInterceptor(AuthInterceptor()); 


  runApp(
    EasyLocalization( 
      supportedLocales: const [Locale("ru"),Locale("en")],
      path: "assets/translations",
      fallbackLocale: const Locale("ru"),
      child:MainApp(
        appProvider: appProvider,
        settingsProvider: settingsProvider, 
        authProvider: authProvider
      )
    )
  );
} 


