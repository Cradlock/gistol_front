


import 'package:app_front/core/core.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelegramAuthBtn extends StatelessWidget {
  

  Future<void> _submit(BuildContext context) async {
    final AuthProvider authProvider = context.read<AuthProvider>();
   
    try{ 
      await authProvider.signWithTelegram(context);

    } on AppException catch(error) {
      ErrorHandler.handle(error);
    }

  }

  @override
  Widget build(BuildContext context) {
final isLoading = context.watch<AuthProvider>().isLoading;
    return ElevatedButton.icon(
      onPressed: isLoading ? null : () => _submit(context), 

      icon: LocalLoaderWrapper(isLoading: isLoading,child: Icon(Icons.telegram)),
      label: const Text('Войти через Telegram'),
    );
  }
}










