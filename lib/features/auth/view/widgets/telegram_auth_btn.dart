


import 'package:app_front/core/core.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelegramAuthBtn extends StatefulWidget {
  
  @override
    State<TelegramAuthBtn> createState() {
      return _TelegramAuthBtn();
    }
}

class _TelegramAuthBtn extends State<TelegramAuthBtn>{
  

  Future<void> _submit() async {
    final AuthProvider authProvider = context.read<AuthProvider>();
   
    try{ 
      await authProvider.signWithTelegram(context);

    } on AppException catch(error) {
      ErrorHandler.handle(error);
    }

  }

  @override
  Widget build(BuildContext context) {

    final AuthProvider authProvider = context.read<AuthProvider>();
    return ElevatedButton.icon(
      onPressed: authProvider.isLoading ? null : _submit, 

      icon: LocalLoaderWrapper(isLoading: authProvider.isLoading,child: Icon(Icons.telegram)),
      label: const Text('Войти через Telegram'),
    );
  }
}










