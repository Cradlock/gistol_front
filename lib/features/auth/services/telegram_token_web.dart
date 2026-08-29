


import 'dart:js_interop';

import 'package:app_front/features/auth/domain/telegram_errors.dart';
@JS('loginWithTelegram')
external JSPromise<JSAny?> _loginWithTelegram(JSString clientId);

Future<String> getTelegramId({
  required String clientId,
  required String redirectUri,
}) async {
  try {
    // Принимаем как JSAny?, чтобы не было ошибок приведения типов на границе
    final JSPromise<JSAny?> promise = _loginWithTelegram(clientId.toJS);
    final JSAny? result = await promise.toDart;

    if (result == null) {
      throw const TelegramAuthCanceledException();
    }

    // Если JS возвращает строку (например, токен или хэш):
    return (result as JSString).toDart;
    
    // Либо если JS возвращает объект, здесь нужно распарсить его поля через package:web
  } catch (e) {
    if (e is TelegramAuthCanceledException) rethrow;
    throw TelegramInternalException(e.toString());
  }
}







