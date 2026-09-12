import 'package:app_front/features/auth/domain/errors.dart';
import 'package:flutter/material.dart';


Future<String> getTelegramId({
  required String clientId,
  required String redirectUri
}) async {
  debugPrint('Hello, you are not on mobile or browser');
  throw AuthPlatformNotSupported();
}




