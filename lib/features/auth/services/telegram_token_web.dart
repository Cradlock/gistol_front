


import 'dart:js_interop';

import 'package:app_front/features/auth/domain/telegram_errors.dart';

@JS('loginWithTelegram')
external JSPromise<JSString> _loginWithTelegram(JSString clientId);


Future<String> getTelegramId({
  required String clientId,
  required String redirectUri 
}) async {
  
  try{
    final JSPromise<JSString> promise = _loginWithTelegram(clientId.toJS);
    
    final JSString result = await promise.toDart;

    return result.toDart;

  } catch (e) {
    final errorString = e.toString().toLowerCase();

    if (errorString.contains('cancel') || errorString.contains('user closed')) {
      throw const TelegramAuthCanceledException();
    } 
    
    if (errorString.contains('не загружен') || errorString.contains('network') || errorString.contains('failed to fetch')) {
      throw const TelegramNetworkException();
    }

    throw TelegramInternalException(e.toString());
  }

}











