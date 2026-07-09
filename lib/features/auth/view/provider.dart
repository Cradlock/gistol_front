
import 'package:app_front/core/api.dart';
import 'package:app_front/core/core.dart';
import 'package:app_front/features/auth/domain/telegram_errors.dart';
import 'package:app_front/features/auth/domain/user.dart';
import 'package:app_front/features/auth/services/main.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class AuthProvider extends ChangeNotifier{
  bool _isLogged = false;
  bool _isLoading = false;
    
  bool get isLoading => _isLoading;
  bool get isLogged => _isLogged;

  final User? _user = null;
  User? get user => _user;
  

  final ApiClient _api = ApiClient();
  final AuthService _service = AuthService();


  Future<void> signWithTelegram(BuildContext context) async {
    _isLoading = true; 
    try{
      await _service.loginWithTelegram(context);
      
      
    } on AppException catch (e) {
      ErrorHandler.handle(e,context: context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
  } 
  
  Future<void> Logout() async {
    _isLogged = false;
    notifyListeners();
  }
  
  void _clearData() {
    _isLogged = false;
  }

  AuthProvider(){}
}

