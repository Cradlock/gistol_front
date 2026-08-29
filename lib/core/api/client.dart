

import 'dart:io';

import 'package:app_front/core/env_key.dart';
import 'package:app_front/core/errors/common.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'domain.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;
  
  final Dio _dio;

  ApiClient._internal() : _dio = Dio() {
    final baseUrl = envKey('BASE_URL');

    if (baseUrl == null || baseUrl.isEmpty) {
      throw StateError(
        '[ApiClient Error]: not found BASE_URL in .env file '

      );
    }

    _dio.options
      ..baseUrl = baseUrl + "api/"
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  }
  
   void addInterceptor(Interceptor interceptor) {
     _dio.interceptors.add(interceptor);
  }

  Future<WrResponse<T>> _guardRequest<T>(
    String path,
    Future<Response<dynamic>> Function() request,
    Converter<T> converter,
  ) async {
    try {
      final response = await request();
      final rawData = response.data;

      T parsedData;
      try {
        parsedData = converter(rawData);
      } catch (e, stackTrace) {
        throw ContractMismatchError(
          path: path,
          targetType: T,
          originalError: e,
          originalStackTrace: stackTrace,
        );
      }

      return WrResponse.success(
        data: parsedData,
        statusCode: response.statusCode ?? 200,
      );

    } on DioException catch (e) {
      int statusCode = e.response?.statusCode ?? 500;
      String msg = e.message ?? 'Unknown error';
      if (
        e.type == DioException.connectionError || 
        e.type == DioException.connectionTimeout ||
        e.type == DioException.sendTimeout ||
        e.error is SocketException
      ) {
        statusCode = 0;
        msg = "Connection error";
      }

      return WrResponse.error(
        statusCode: statusCode,
        message: msg,
      );
    } 
    // Обратите внимание: общий catch (e) убран, 
    // чтобы ContractMismatchError (наследующийся от Error) летел наверх не перехваченным.
  }
  
  dynamic _formatData<T>(ToJsonable? data) {
    return data is ToJsonable ? data.toJson() : data;
  }


  Future<WrResponse<T>> get<T>(
    String path,{
      required Converter<T> converter,
      Map<String, dynamic>? queryParameters, 
      Options? options
    }) async  {
      return _guardRequest(
        path,
        () => _dio.get<Map<String, dynamic>>(path, queryParameters: queryParameters, options: options),
        converter,
      );   
  }

  Future<WrResponse<T>> post<T>(
    String path, {
    required Converter<T> converter,
    ToJsonable? data,
    Options? options,
  }) {
    return _guardRequest(
      path,
      () => _dio.post<Map<String, dynamic>>(path, data: _formatData(data), options: options),
      converter,
    );
  }

  Future<WrResponse<T>> put<T>(
    String path, {
    required Converter<T> converter,
    ToJsonable? data,
    Options? options,
  }) {
    return _guardRequest(
      path,
      () => _dio.put<Map<String, dynamic>>(path, data: _formatData(data), options: options),
      converter,
    );
  }

  Future<WrResponse<T>> patch<T>(
    String path, {
    required Converter<T> converter,
    ToJsonable? data,
    Options? options,
  }) {
    return _guardRequest(
      path,
      () => _dio.patch<Map<String, dynamic>>(path, data: _formatData(data), options: options),
      converter,
    );
  }

  Future<WrResponse<T>> delete<T>(
    String path, {
    required Converter<T> converter,
    Map<String, dynamic>? queryParameters,
    ToJsonable? data,
    Options? options,
  }) {
    return _guardRequest(
      path,
      () => _dio.delete<Map<String, dynamic>>(path, queryParameters: queryParameters, data: _formatData(data), options: options),
      converter,
    );
  }
}





