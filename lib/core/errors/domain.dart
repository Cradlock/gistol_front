


import 'package:flutter/foundation.dart';

@immutable
abstract class AppException implements Exception {
  
  final String localKey;
  final VoidCallback? onErrorAction;
  const AppException(
    this.localKey,{this.onErrorAction});
  
}








