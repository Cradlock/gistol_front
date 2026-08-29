

import 'package:app_front/core/api/domain.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/domain/auth.dart';

class TelegramAuthResponse {
  final RefreshResponse tokens;
  final bool isNew;
  final User user;

  TelegramAuthResponse({
    required this.tokens,
    required this.isNew,
    required this.user
  });

  factory TelegramAuthResponse.converter(dynamic data){
    final map = data as Map<String,dynamic>;

    return TelegramAuthResponse(
      tokens: RefreshResponse(access_token: map["access_token"], refresh_token: map["refresh_token"]),
      isNew: map["is_new"] as bool,
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


