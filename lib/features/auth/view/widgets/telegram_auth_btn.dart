


import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/core/widgets/loader_wrapper.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelegramAuthBtn extends StatelessWidget {
  

  Future<void> _submit(BuildContext context) async {
    final AuthProvider authProvider = context.read<AuthProvider>();
   
    try{ 
      await authProvider.signWithTelegram(context);
    } on AppException catch (error) {
      if (!context.mounted) return;
      ErrorHandler.handle(error, context: context);
    } catch (error) {
      if (!context.mounted) return;
      ErrorHandler.handle(
        TelegramInternalException(error.toString()),
        context: context,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
final isLoading = context.watch<AuthProvider>().isLoading;
    return LocalLoaderWrapper( isLoading:  isLoading,child:ElevatedButton.icon(
      onPressed: isLoading ? null : () => _submit(context), 
      icon: Icon(Icons.telegram),
      label: Text(AppStrings.auth.sign_with_telegram.tr()),
    ));
  }
}










