import 'package:app_front/core/core.dart';

class RefreshRequest implements ToJsonable {
  final String _refresh_token;

  const RefreshRequest({required this._refresh_token});

  @override
  Map<String, dynamic> toJson() {
    return {"refresh_token": _refresh_token};
  }
}

class RefreshResponse {
  final String _access_token;
  final String _refresh_token;

  String get access_token => _access_token;
  String get refresh_token => _refresh_token;

  RefreshResponse({required this._access_token, required this._refresh_token});

  factory RefreshResponse.converter(dynamic json) {
    final map = Map<String, dynamic>.from(json as Map);
    final accessToken = map['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw const FormatException('Refresh response is missing access_token');
    }
    return RefreshResponse(
      access_token: accessToken,
      refresh_token: map['refresh_token'] as String? ?? '',
    );
  }
}
