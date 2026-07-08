


import 'package:app_front/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TelegramAuthBtn extends StatelessWidget {


  TelegramAuthBtn({super.key});
  

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.read<AuthProvider>();

    return ElevatedButton.icon(
      onPressed: () async {
        authProvider.signWithTelegram(context);
      },
      icon: const Icon(Icons.telegram),
      label: const Text('Войти через Telegram'),
    );
  }
}










