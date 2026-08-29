

import 'package:app_front/core/core.dart';

class RefreshRequest implements ToJsonable {
    final String _refresh_token;
    

    const RefreshRequest({required this._refresh_token});

    @override
    Map<String,dynamic> toJson(){ 
      return {
        "refresh_token":_refresh_token
      };
    }


}

class RefreshResponse {
    final String _access_token;
    final String _refresh_token;

    String get access_token => _access_token;
    String get refresh_token => _refresh_token;

    RefreshResponse({required this._access_token,required this._refresh_token});

    factory RefreshResponse.converter(dynamic json) {


      return RefreshResponse(
        access_token: json["access_token"],
        refresh_token: json["refresh_token"]
      );
    }
}
