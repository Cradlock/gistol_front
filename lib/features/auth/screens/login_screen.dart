import 'package:app_front/core/widgets/app_icon.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущую тему и цветовую схему
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface, // Автоматически адаптируется под тему
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка-логотип в адаптивном круге

                const AppIcon(size: 120), 
                const SizedBox(height: 32),

               // Наша кнопка авторизации Telegram
                TelegramAuthBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
