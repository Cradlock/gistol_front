
export 'telegram_token_stub.dart'
    if (dart.library.html) 'telegram_token_web.dart'
    if (dart.library.io) 'telegram_token_mobile.dart';

