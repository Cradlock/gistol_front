import 'package:app_front/core/core.dart';
import 'package:app_front/core/env_key.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/domain/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';


import 'telegram_token_stub.dart'
    if (dart.library.html) 'telegram_token_web.dart'
    if (dart.library.io) 'telegram_token_mobile.dart';

class AuthService {
  
  final ApiClient _api = ApiClient();
  
  String token = "not";

  final String _botClientId = envKey("TELEGRAM_CLIENT_ID");
  final String _botRedirectUri = envKey("TELEGRAM_REDIRECT_URI");
    
  Future<WrResponse<TelegramAuthResponse>> loginWithTelegram(BuildContext context) async {
    String idToken = await getTelegramId(
      clientId: _botClientId, redirectUri: _botRedirectUri);
    
    debugPrint(idToken);

    TelegramAuthRequest data = TelegramAuthRequest(idToken: "");
    return  _api.post<TelegramAuthResponse>("auth/telegram",data: data, converter: TelegramAuthResponse.converter);
  }


  Future<WrResponse<User>> me() async {
    return await _api.get<User>("student/me", converter: User.converter);
  }

}


