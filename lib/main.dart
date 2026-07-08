




import 'package:app_front/core/api.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/settings/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:app_front/entry/entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");  

  final apiClient = ApiClient();
  apiClient.addInterceptor(AuthInterceptor()); 

  final settingsProvider = SettingsProvider();
  final authProvider = AuthProvider();
  
  await settingsProvider.initSettings();

  runApp( 
    MainApp(
      settingsProvider: settingsProvider, authProvider: authProvider
    )
  );
} 


