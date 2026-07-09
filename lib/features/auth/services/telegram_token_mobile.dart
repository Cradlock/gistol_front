


import 'package:app_front/core/core.dart';
import 'package:app_front/features/auth/domain/telegram_errors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';

Future<String> getTelegramId({
  required String clientId,
  required String redirectUri
}) async {
  
try{
  FlutterTelegramAuth.init(clientId: clientId, redirectUri: redirectUri,scopes: ['openid','profile','phone']);
  
  final String? idToken = await FlutterTelegramAuth.login();
  
  if (idToken == null){
    throw TelegramAuthCanceled();
  }

  return idToken;
} on PlatformException catch(e){
  debugPrint('Platform error: $e');
  rethrow;
} catch (e) {
    rethrow;
  }
}
