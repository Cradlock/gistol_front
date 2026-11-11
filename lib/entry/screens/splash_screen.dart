import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/core/widgets/app_btn.dart';
import 'package:app_front/core/widgets/app_icon.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Стартовый экран. Проверяет сохранённые токены, а куда пойдёт пользователь
/// (логин, анкета, профиль), решает роутер, как только проверка завершится:
/// он слушает [AuthProvider] и до этого момента держит всех на `/`.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final provider = context.read<AuthProvider>();
    if (_failed) setState(() => _failed = false);

    try {
      await provider.checkLoginStatus();
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _failed = true);
      ErrorHandler.handle(error);
    } catch (error, stackTrace) {
      debugPrint('Startup auth check failed: $error\n$stackTrace');
      if (mounted) setState(() => _failed = true);
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
            const AppIcon(size: 120),
            const SizedBox(height: 32),
            Text(
              "Gistology Academy",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            if (_failed)
              AppBtn(
                text: AppStrings.common.retry.tr(),
                onPressed: _init,
              )
            else
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
