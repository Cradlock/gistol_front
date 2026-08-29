

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
    final map = data as Map<String,dynamic>;
    
    debugPrint(map['user'].toString());

    return TelegramAuthResponse(
      tokens: RefreshResponse(
        access_token: map["access_token"], 
        refresh_token: map["refresh_token"]
      ),
      user: User.converter(map['user'])
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


