



import 'package:app_front/core/core.dart';
import 'package:app_front/entry/entry.dart';
import 'package:flutter/material.dart';
// =============================================================================
// SYSTEM ERRORS ("system")
// =============================================================================

abstract class SystemException extends AppException {
  const SystemException(
    super.localKey);
  
}




/// "Server error"
class ServerTroubleException extends SystemException {
  const ServerTroubleException()
      : super('system.server_trouble');
}



// =============================================================================
// NETWORK ERRORS ("network")
// =============================================================================
abstract class NetworkException extends AppException {
  const NetworkException(
    super.localKey,{
    super.onErrorAction // Ошибки сети обычно показывают пользователю
  });
}

/// "Not internet connections"
class NoConnectionException extends NetworkException {
  
  NoConnectionException() : 
    super('network.no_connection',onErrorAction: () { 
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("Redirect on /no-connection ");
        AppRouter.router.go("/no-connection");
      });
    
    });
}


/// ""


// =============================================================================
// AUTH ERRORS ("auth")
// =============================================================================

abstract class AuthException extends AppException {
  const AuthException(
    super.localKey, {
    super.onErrorAction// Ошибки ввода авторизации показывают пользователю
  });
}

/// Incorrect login
class InvalidSignDataException extends AuthException {
  const InvalidSignDataException() : super('errors.auth.invalid_sign_data');
}

class SessionExpired extends AuthException {
  SessionExpired() : super('errors.auth.session_expired',onErrorAction: () {
     
     WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("Redirect on /login ");
        AppRouter.router.push("/login");
      });
    }
  );

}


