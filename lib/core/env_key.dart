import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String envKey(String key, {String defaultValue = ''}) {
  final value = dotenv.env[key];
  if (value == null || value.isEmpty) {
    debugPrint('⚠️ [Env Error]: Ключ "$key" не найден в переменных окружения (.env)');
    if (defaultValue.isEmpty){
      throw StateError("[Env Error] Key $key not found on (.env) and not default value");
    }
    return defaultValue;
  }
  return value;
}
