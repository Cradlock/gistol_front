



import 'package:app_front/core/core.dart';
import 'package:app_front/core/widgets/app_icon.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; 


class SplashScreen extends StatefulWidget{

  const SplashScreen({super.key});

  @override
    State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen>{
  @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_){
        _startAppInit();
      });
    } 

  Future<void> _startAppInit() async { 
    final AuthProvider authProvider = context.read<AuthProvider>();
 
    if(!mounted) return;

    try{ 
      await authProvider.checkLoginStatus();
    } on TelegramNetworkException {
      context.go("/no-internet");
    } on TelegramAuthCanceledException {
      context.go("/login");
    } on AppException catch (error) {
      ErrorHandler.handle(error,context: context);
    }

    if(!authProvider.isLogged) {
      context.go("/login");
    } else {
      context.go("/home");
    }
  }


@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  return Scaffold(
    backgroundColor: colors.surface, 
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Контейнер для логотипа, адаптирующийся под тему
          const AppIcon(size: 120), 
          const SizedBox(height: 32),
          
          // Текст названия академии, использующий шрифты из темы
          Text(
            "Gistology Academy",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface, // Адаптивный цвет текста
            ),
          ),
          const SizedBox(height: 24),
          
          // Нативный спиннер загрузки
          CircularProgressIndicator(
            strokeWidth: 3,
            // Спиннер красится в главный цвет текущей темы
            valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
          ),
        ],
      ),
    ),
  );
}
}
