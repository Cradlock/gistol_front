import 'dart:js_interop';
import 'package:app_front/features/auth/domain/errors.dart';
import 'package:flutter/widgets.dart';

@JS('loginWithTelegram')
external JSPromise<JSAny?> _loginWithTelegram(JSString clientId);

Future<String> getTelegramId({
  required String clientId,
  required String redirectUri,
}) async {
  try {
    final JSPromise<JSAny?> promise = _loginWithTelegram(clientId.toJS);
    final JSAny? result = await promise.toDart;

    if (result == null) {
      throw TelegramUserCancelled();
    }

    // Приведение типов на границе JS -> Dart
    if (result.isA<JSString>()) {
      return (result as JSString).toDart;
    }

    // Если JS вернет некорректный тип вместо строки
    throw TelegramInternalException("Invalid JS return type: expected string token");

  } catch (e) {
    debugPrint("Error on Telegram Web Auth: $e");

    // 1. Уже обработанные доменные исключения пропускаем далее
    if (e is TelegramAuthException) {
      rethrow;
    }

    final String errorMsg = e.toString().toLowerCase();

    // 2. Скрипт Telegram не подключен на HTML-странице или заблокирован (AdBlock)
    if (errorMsg.contains("скрипт telegram не загружен") || 
        errorMsg.contains("telegram is not defined") ||
        errorMsg.contains("login is undefined")) {
      throw TelegramScriptNotLoaded();
    }

    // 3. Отмена пользователем из reject(...) в JS
    if (errorMsg.contains("authorization cancel") || 
        errorMsg.contains("user_declined") ||
        errorMsg.contains("popup_closed")) {
      throw TelegramUserCancelled();
    }

    // 4. Ошибки конфигурации (origin, bad client_id, bad redirect_uri)
    if (errorMsg.contains("origin_mismatch") || 
        errorMsg.contains("invalid client_id") ||
        errorMsg.contains("bot_domain_invalid")) {
      throw TelegramInvalidConfig(e.toString());
    }

    // 5. Ошибки сети во время вызова виджета
    if (errorMsg.contains("network") || 
        errorMsg.contains("failed to fetch") ||
        errorMsg.contains("offline")) {
      throw TelegramNetworkException();
    }

    // 6. Ошибка каста типов darta (TypeError / CastError)
    if (e is TypeError) {
      throw TelegramInternalException("JS Interop Cast Error: $e");
    }

    // 7. Все остальные необработанные JS-ошибки
    throw TelegramInternalException(e.toString());
  }
}
