

import 'package:app_front/core/api/domain.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/domain/auth.dart';
import 'package:flutter/cupertino.dart';

class TelegramAuthResponse {
  final RefreshResponse tokens;
  final User user;

  TelegramAuthResponse({
    required this.tokens,
    required this.user
  });

  factory TelegramAuthResponse.converter(dynamic data){
    if (data is! Map) {
      throw const FormatException('Telegram auth payload must be an object');
    }
    final map = Map<String, dynamic>.from(data);
    final userPayload = map['user'];
    if (userPayload == null) {
      throw const FormatException('Telegram auth response is missing user');
    }

    return TelegramAuthResponse(
      tokens: RefreshResponse.converter({
        'access_token': map['access_token'],
        'refresh_token': map['refresh_token'],
      }),
      user: User.converter(userPayload),
    );
  }

}

class TelegramAuthRequest extends ToJsonable {
  final String idToken;

  TelegramAuthRequest({required this.idToken});

  Map<String,dynamic> toJson(){
    return {
      "id_token":idToken
    };
  }
}


