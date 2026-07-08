


// lib/core/api/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  // Нам нужен отдельный чистый экземпляр Dio для запроса /refresh.
  // Если использовать тот же самый Dio, где висит этот интерцептор,
  // мы уйдем в бесконечную рекурсию (зациклимся).
  final Dio _refreshDio = Dio(BaseOptions(baseUrl: dotenv.get("BASE_URL")));

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    // Если токен есть в базе, автоматически лепим его ко всем запросам
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options); // Пускаем запрос дальше
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Если ошибка НЕ связана с авторизацией (не 401), просто прокидываем её дальше
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    // Если рефреш-токена нет, то и обновлять нечего — отправляем разлогинивать юзера
    if (refreshToken == null || refreshToken.isEmpty) {
      _handleLogout();
      return handler.next(err);
    }

    try {
      // 1. Пытаемся обновить токены на бэкенде
      // Важно: передаем refresh в заголовке или body, как требует твой бэк
      final response = await _refreshDio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final newAccess = data['access_token'] as String;
        final newRefresh = data['refresh_token'] as String;

        // 2. Сохраняем свежие токены в SharedPreferences
        await prefs.setString('access_token', newAccess);
        await prefs.setString('refresh_token', newRefresh);

        // 3. Берем старый упавший запрос, обновляем в нем заголовок на новый токен
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newAccess';

        // 4. Повторяем запрос заново!
        // Создаем копию оригинального запроса через дефолтный Dio
        final cloneDio = Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
        final clonedResponse = await cloneDio.request(
          requestOptions.path,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );

        // Возвращаем успешный результат вместо ошибки 401! UI даже не поймет, что был сбой
        return handler.resolve(clonedResponse);
      }
    } catch (e) {
      // Если даже ручка /refresh упала (например, рефреш токен тоже устарел или отозван)
      // Значит сессия полностью мертва — принудительно разлогиниваем пользователя
      await _handleLogout();
    }

    return handler.next(err);
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    
  }
}
