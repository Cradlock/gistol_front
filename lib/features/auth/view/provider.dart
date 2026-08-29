
import 'package:app_front/core/core.dart';
import 'package:app_front/entry/entry.dart';
import 'package:app_front/features/auth/auth.dart';
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
    
  List<int>? years;
  ValueNotifier<List<Group>> groups = ValueNotifier([]);

  bool get isLogged => _isLogged;

  User? _user = null;
  User? get user => _user;
  

  
  
  final AuthService _service = AuthService();

  bool isComplete() {
  final user = _user;
  if (user == null) return false;

  return user.name != null && 
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
    try{
      final response = await _service.loginWithTelegram(context);
      

      final tokens = response.data!.tokens;
      await saveTokens(tokens.access_token, tokens.refresh_token);

      //_user = response.data!.user;
      

      if(!isComplete()){
        final bool? res = await showAppDialog<bool>(
          context: context,
          content: CompleteProfileCard() 
        );

      }
      
    } on AppException catch (e) {
      ErrorHandler.handle(e);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      notifyListeners();
    }
  }
  
  Future<void> initDataComplete() async {

  } 
  
  Future<void> getGroups(int year) async {

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

