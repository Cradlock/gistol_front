import 'package:app_front/core/core.dart';
import 'package:app_front/features/auth/domain/errors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_telegram_auth/flutter_telegram_auth.dart';

Future<String> getTelegramId({
  required String clientId,
  required String redirectUri,
}) async {
  try {
    FlutterTelegramAuth.init(
      clientId: clientId,
      redirectUri: redirectUri,
      scopes: ['openid', 'profile', 'phone'],
    );

    final String? idToken = await FlutterTelegramAuth.login();

    if (idToken == null) {
      // 1. Пользователь закрыл Custom Tabs / Safari View Controller
      throw TelegramUserCancelled();
    }

    return idToken;
  } on PlatformException catch (e) {
    debugPrint('Platform error: $e');

    // 2. Отсутствие браузера / Custom Tabs или неверная платформа
    if (e.code == 'ACTIVITY_NOT_FOUND' || e.code == 'channel-error') {
      throw AuthPlatformNotSupported();
    }

    // 3. Неверные параметры clientId или redirectUri
    if (e.code == 'invalid_request' || e.code == 'invalid_client') {
      throw TelegramInvalidConfig(e.message);
    }

    // 4. Ошибка сети при OAuth-редиректе
    if (e.code == 'network_error' || e.code == 'connection_failed') {
      throw TelegramNetworkException();
    }

    // Прочие ошибки native-плагина
    throw TelegramInternalException(e.message);
  } on TelegramAuthException {
    rethrow;
  } catch (e) {
    debugPrint('Unexpected Telegram Auth error: $e');
    throw TelegramInternalException(e.toString());
  }
}
