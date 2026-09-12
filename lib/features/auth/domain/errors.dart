



import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/entry/entry.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';





// =============================================================================
// AUTH ERRORS ("auth")
// =============================================================================
// =============================================================================
// AUTH ERRORS ("auth")
// =============================================================================
abstract class TelegramAuthException extends AppException {
  final String? message;

  TelegramAuthException({
    required super.localKey,
    this.message,
    super.displayType = ExceptDisplayType.toast,
    super.onErrorAction,
  });

  @override
  Widget buildCustomDialog(BuildContext context) {
    final theme = Theme.of(context);

    if (message == null || message!.isEmpty) {
      return super.buildCustomDialog(context);
    }
    
    switch (displayType) {
      case ExceptDisplayType.redirect:
        // Редирект не имеет UI-представления
        return const SizedBox.shrink();

      case ExceptDisplayType.modal:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localKey.tr(), style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              message!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 16),
            if (onErrorAction != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onErrorAction?.call(context);
                },
                child: Text(AppStrings.common.retry.tr()),
              ),
          ],
        );

      case ExceptDisplayType.toast:
        return Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localKey.tr(),
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                  Text(
                    message!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.onErrorContainer.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case ExceptDisplayType.overlay:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(localKey.tr(), style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}

/// Платформа не поддерживается
class AuthPlatformNotSupported extends TelegramAuthException {
  AuthPlatformNotSupported()
      : super(
          displayType: ExceptDisplayType.overlay,
          localKey: AppStrings.auth.platform_not_support_error,
        );
}

/// Пользователь сам закрыл окно или отменил вход в Telegram
class TelegramUserCancelled extends TelegramAuthException {
  TelegramUserCancelled()
      : super(
          displayType: ExceptDisplayType.toast,
          localKey: AppStrings.auth.user_cancelled,
        );
}

/// JS-скрипт Telegram не загрузился (AdBlocker, проблемы с сетью на старте Web)
class TelegramScriptNotLoaded extends TelegramAuthException {
  TelegramScriptNotLoaded()
      : super(
          displayType: ExceptDisplayType.toast,
          localKey: AppStrings.auth.script_not_loaded,
        );
}

/// Неверный clientId, redirectUri или origin
class TelegramInvalidConfig extends TelegramAuthException {
  TelegramInvalidConfig([String? details])
      : super(
          displayType: ExceptDisplayType.overlay,
          localKey: AppStrings.auth.config_invalid,
          message: details,
        );
}

/// Ошибка сети во время прохождения OAuth / взаимодействия с Telegram
class TelegramNetworkException extends TelegramAuthException {
  TelegramNetworkException()
      : super(
          displayType: ExceptDisplayType.toast,
          localKey: AppStrings.auth.network_error,
        );
}

/// Неизвестная или внутренняя ошибка JS/Native SDK
class TelegramInternalException extends TelegramAuthException {
  TelegramInternalException([String? details])
      : super(
          displayType: ExceptDisplayType.toast,
          localKey: AppStrings.auth.internal_error,
          message: details,
        );
}


/// Не валидный токен при авторизации через тг
class InvalidTelegramTokens extends AppException {
  InvalidTelegramTokens() : super(
    displayType: ExceptDisplayType.toast,
    localKey: AppStrings.auth.invalid_token_error
  );

}


/// Не валидные токены авторизации
class UnauthenticatedException extends AppException {
  UnauthenticatedException()
      : super(
          onErrorAction: (BuildContext context) {
            context.go("/login"); 
          },
          displayType: ExceptDisplayType.redirect,
          localKey: AppStrings.auth.error_session_expired,
          
        );
}

/// Не потвержденный аккаунт
class NotConfirmedAccount extends AppException {
  NotConfirmedAccount() 
    : super(
      displayType: ExceptDisplayType.toast,
      localKey: AppStrings.auth.not_confirmed_account 
    );

}

/// 4. Ошибка валидации анкеты студента (HTTP 400 / 422 на student/complete)
class InvalidProfileDataException extends AppException {
  InvalidProfileDataException({super.onErrorAction})
      : super(
          displayType: ExceptDisplayType.toast,
          localKey: AppStrings.auth.error_invalid_profile_data,
        );
}
