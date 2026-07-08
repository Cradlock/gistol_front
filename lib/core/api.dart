

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;
  
  final Dio _dio;

  ApiClient._internal() : _dio = Dio() {
    final baseUrl = dotenv.env['BASE_URL'];

    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError(
        '[ApiClient Error]: not found BASE_URL in .env file '
      );
    }

    _dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 5)
      ..receiveTimeout = const Duration(seconds: 5)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  }
  
   void addInterceptor(Interceptor interceptor) {
     _dio.interceptors.add(interceptor);
  }

   Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
     return _dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

   Future<Response<T>> post<T>(String path, {dynamic data, Options? options})    {
     return _dio.post<T>(path, data: data, options: options);
}

}


