import 'dart:async';

import 'package:app_front/core/core.dart';
import 'package:flutter/material.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget content,
}) async {
  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      content: content,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}



Future<T?> safeExecute<T>(FutureOr<T> Function() action,{ 
  BuildContext? context
}) async {
  try {
    return await action();
  } on AppException catch(e){
    
    ErrorHandler.handle(e,context: context);
    return null;
  } catch (e) {
    debugPrint("[Custom debugger] error on safeExecute: $e");
    return null;
  }
}
