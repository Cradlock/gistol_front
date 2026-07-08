


import 'package:app_front/features/auth/domain/telegram_errors.dart';
import 'package:flutter/cupertino.dart';


Future<String> getTelegramId({
  required String clientId,
  required String redirectUri
}) async => throw AuthPlatformNotSupported(requiredPlatform: "Only web or mobile");





