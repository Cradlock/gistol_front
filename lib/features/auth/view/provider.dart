
import 'package:app_front/core/core.dart';
import 'package:app_front/entry/entry.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:app_front/features/auth/domain/errors.dart';
import 'package:app_front/features/auth/domain/telegram_errors.dart';
import 'package:app_front/features/auth/domain/user.dart';
import 'package:app_front/features/auth/services/main.dart';
import 'package:app_front/features/auth/view/widgets/complete_profile_card.dart';
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
  ValueNotifier<bool> isLoadingTgSign = ValueNotifier(false);

  bool get isLogged => _isLogged;

  User? _user = null;
  User? get user => _user;
  
  final AuthService _service = AuthService();
  Future<void> _safeExecute(
    Future<void> Function() action, {
      ValueNotifier<bool>? customLoader, 
      bool globalLoader = true
  }) async {
    final loader = globalLoader ? isLoading : (customLoader ?? ValueNotifier(false));
    loader.value = true;
    try {
      await action();
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    } catch (e) {
      debugPrint("[Auth Provider] $e");
    } finally {

      loader.value = false;
    }
  }
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
    isLoading.value = true;
    isLoadingTgSign.value = true;
    try{
      final response = await _service.loginWithTelegram(context);
      isLoadingTgSign.value = false;


      final tokens = response.data!.tokens;
      await saveTokens(tokens.access_token, tokens.refresh_token);

      isLoading.value = false;
      _user = response.data!.user;
      

      if(!isComplete()){
        final res = await showAppDialog<bool>(
          context: context,
          content: CompleteProfileCard() 
        ); 
         

      }
      
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
    }
  }
  
  Future<List<int>> initDataComplete() async {
      final result = await _service.getYears();
      
      if (result.statusCode == 0) {
        throw NoConnectionException();
      }
      return result.data!.years;
  } 
  
  Future<List<Group>?> getGroups(int year) async { 
      
      try{ 
        final result = await _service.getGroups(year);
      
        return result.data!.groups;
      } on AppException catch(e) {
        ErrorHandler.handle(e);
      } 
  }


  Future<void> completeProfile(
    UserCompleteRequest data 
  ) async {
    
    await _safeExecute(() async {
      final response = await _service.completeStudent(data); 
      
    });
  }

  Future<void> checkLoginStatus() async {
    isLoading.value = true;
    currentError = null;

    try {
      final response = await _service.me();
      
      if (response.statusCode != 200 || response.data == null) {
        if (response.statusCode == 500) {
          currentError = NoConnectionException();
        }
         
        isLoading.value = false;
        return ; // Ошибка — пользователя на логин!
      }      

      _user = response.data;
      _isLogged = true;
      isLoading.value = false;
      return ;

    } catch (e) {
      debugPrint(e.toString()); 
      isLoading.value = false;
      return ;
    }
  } 
  
 

  AuthProvider(){}


}

