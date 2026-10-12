import 'package:app_front/core/core.dart';
import 'package:app_front/core/errors/common.dart';
import 'package:app_front/entry/entry.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/domain/errors.dart';
import 'package:app_front/features/auth/domain/user.dart';
import 'package:app_front/features/auth/services/main.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthProvider extends ChangeNotifier {
  User? _user = null;
  AppException? currentError;
  bool _isLoading = false;
  DateTime? _notConfirmedToastAt;

  bool get isLoading => _isLoading;
  bool get isLogged => _user != null;
  bool get isConfirmed => _user?.confirmed == true;
  User? get user => _user;

  final AuthService _service = AuthService();

  bool isComplete() {
    final user = _user;
    if (user == null) return false;

    return user.year != null &&
        user.name != null &&
        user.name!.isNotEmpty &&
        user.surname != null &&
        user.surname!.isNotEmpty &&
        user.groupId != null;
  }

  Future<void> saveTokens(String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  }

  Future<void> signWithTelegram(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _service.loginWithTelegram(context);
      if (!response.isSuccess || response.data == null) {
        throw TelegramInternalException(response.errorMessage);
      }
      final tokens = response.data!.tokens;
      await saveTokens(tokens.access_token, tokens.refresh_token);
      _user = response.data!.user;
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('Telegram login failed: $error\n$stackTrace');
      throw TelegramInternalException(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<int>> initDataComplete() async {
    final result = await _service.getYears();
    if (!result.isSuccess || result.data == null) {
      throw InvalidProfileDataException();
    }
    return result.data!.years;
  }

  Future<List<Group>?> getGroups(int year) async {
    final result = await _service.getGroups(year);
    if (!result.isSuccess || result.data == null) {
      throw InvalidProfileDataException();
    }
    return result.data!.groups;
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      final accessToken = prefs.getString('access_token');
      final hasRefresh = refreshToken != null && refreshToken.isNotEmpty;
      final hasAccess = accessToken != null && accessToken.isNotEmpty;

      if (!hasRefresh && !hasAccess) {
        _user = null;
        return;
      }

      if (hasRefresh) {
        final refreshed = await AuthInterceptor.refreshStoredSession();
        if (!refreshed) {
          _user = null;
          return;
        }
      }

      final response = await _service.me();
      if (!response.isSuccess || response.data == null) {
        _user = null;
        return;
      }
      _user = response.data;
    } on UnauthenticatedException {
      _user = null;
    } on DioException catch (error) {
      _user = null;
      if (error.type == DioExceptionType.connectionError) {
        throw NoInternetException();
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      }
      throw ServerException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _user = null;
    currentError = null;
    _notConfirmedToastAt = null;
    notifyListeners();
  }

  void warnNotConfirmed() {
    if (isConfirmed) return;
    final now = DateTime.now();
    final last = _notConfirmedToastAt;
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return;
    }
    _notConfirmedToastAt = now;
    ErrorHandler.handle(NotConfirmedAccount());
  }

  Future<void> completeProfile(UserCompleteRequest data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.completeStudent(data);
      if (!response.isSuccess || response.data == null) {
        throw InvalidProfileDataException();
      }
      _user = response.data;
    } on AppException {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  AuthProvider() {}
}
