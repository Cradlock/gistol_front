



import 'package:app_front/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:app_front/features/auth/services/telegram_token_stub.dart'
  if(dart.library.html) 'package:app_front/features/auth/services/telegram_token_web.dart'
  if(dart.library.io) 'package:app_front/features/auth/services/telegram_token_mobile.dart';

class AuthService {
  
  final ApiClient _api = ApiClient();
  
  String token = "not";

  final String _botClientId = dotenv.get("TELEGRAM_CLIENT_ID");
  final String _botRedirectUri = dotenv.get("TELEGRAM_REDIRECT_URI");
    
  Future<void> loginWithTelegram(BuildContext context) async {
   String idToken = await getTelegramId(clientId: _botClientId, redirectUri: _botRedirectUri);      
  
  }



}


