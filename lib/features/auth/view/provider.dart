
import 'package:app_front/core/core.dart';
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



class AuthProvider extends ChangeNotifier{
  User? _user = null;
  AppException? currentError;
  bool _isLoading = false; 

  bool get isLoading => _isLoading;
  bool get isLogged => _user != null;
  User? get user => _user;
  
  final AuthService _service = AuthService();
  
  bool isComplete() {
    final user = _user;
    if (user == null) return false;

    return user.year != null && user.name != null && 
         user.name!.isNotEmpty &&
         user.surname != null &&
         user.surname!.isNotEmpty &&
         user.group != null;
  }
  

  Future<void> saveTokens(String access,String refresh) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);
  } 
  

  Future<void> signWithTelegram(BuildContext context) async {
    final response = await _service.loginWithTelegram(context);

    final tokens = response.data!.tokens;
    await saveTokens(tokens.access_token, tokens.refresh_token);

    _user = response.data!.user;
  }
  

  Future<List<int>> initDataComplete() async {
      final result = await _service.getYears();
      return result.data!.years;
  } 
  
  Future<List<Group>?> getGroups(int year) async { 
      final result = await _service.getGroups(year);
      return result.data!.groups;
  }


  Future<void> checkLoginStatus() async {
      _isLoading = true;
      try{
      final response = await _service.me();
      _user = response.data;
      } catch (e) {
        rethrow;
      } finally {
      _isLoading = false;
      }
  }
  
  
 Future<void> completeProfile(UserCompleteRequest data) async {
  _isLoading = true;
  notifyListeners(); // 1. GoRouter узнает о старте загрузки

  try {
    final response = await _service.completeStudent(data);
    _user = response.data; // 2. Теперь _user заполнена (isComplete() вернет true)
  } finally {
    _isLoading = false;
    notifyListeners(); // 3. GoRouter повторно вызывает redirect!
  }
}
  AuthProvider(){}


}

