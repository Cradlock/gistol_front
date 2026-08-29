
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

  AppException? currentError;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
    
  bool get isLogged => _isLogged;

  final User? _user = null;
  User? get user => _user;
  

  final AuthService _service = AuthService();


  Future<void> signWithTelegram(BuildContext context) async {
    isLoading.value = true; 
    try{
      await _service.loginWithTelegram(context);
       

      
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    } catch (e) {
      debugPrint("Erro on loginWithTelegram: ${e.toString()}");
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
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

