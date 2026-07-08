import 'package:app_front/core/core.dart';
import 'package:flutter/cupertino.dart';


@immutable
class AuthPlatformNotSupported extends AppException {
  final String requiredPlatform;

const AuthPlatformNotSupported({required this.requiredPlatform}) 
: super(
  'errors.platform.unsupported',
  shouldShowToUser: true
);
}



@immutable
abstract class TelegramException extends AppException {
  const TelegramException(
    super.localKey,{ super.shouldShowToUser}
  );
}

class TelegramAuthCanceled extends TelegramException {
  const TelegramAuthCanceled() : 
    super('errors.telegram.canceled');
}



// Пользователь сам отменил авторизацию (UI не должен орать об ошибке, просто выключаем спиннер)
class TelegramAuthCanceledException extends AppException {
  const TelegramAuthCanceledException() 
      : super('errors.telegram.canceled', shouldShowToUser: false);
}

// Нет интернета или скрипт заблокирован (adblock/network error)
class TelegramNetworkException extends AppException {
  const TelegramNetworkException() 
      : super('errors.network.no_connection', shouldShowToUser: true);
}

// Что-то пошло не так на стороне Telegram (кривые параметры clientId и т.д.)
class TelegramInternalException extends AppException {
  final String details;
  const TelegramInternalException(this.details) 
      : super('errors.telegram.wrong_args', shouldShowToUser: false);
}



