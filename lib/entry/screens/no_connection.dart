import 'dart:async';

import 'package:app_front/core/core.dart';
import 'package:app_front/entry/entry.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';



class NoConnectiontScreen extends StatefulWidget{
  const NoConnectiontScreen({super.key});
  
  @override
  State<NoConnectiontScreen> createState() => _NoInternetScreenState();

}


class _NoInternetScreenState extends State<NoConnectiontScreen>{
  bool _isRetrying = false;


  @override
    void initState() {
      super.initState();
      

    }

  
  @override 
  void dispose(){
    super.dispose();
  }

  void _retryConnection() async {
    if(_isRetrying) return;
    
    setState(() {
          _isRetrying = true;
    });
    
    final authProvider = context.read<AuthProvider>();
    

    final isLogged = await authProvider.checkLoginStatus();
    
    if(authProvider.currentError != null) {
      ErrorHandler.handle(authProvider.currentError!); 
    } else {
      AppRouter.router.go("/");
    }

    setState(() {
      _isRetrying = false;
    });

  }
  
  @override 
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              const Icon(Icons.wifi_off_rounded),
              const SizedBox(height: 24),

              Text(
                "errors.network.no_connection_label".tr(),
                style: Theme.of(context).textTheme.titleMedium
              ),
              const SizedBox(height: 12),
              
ElevatedButton.icon(
  // Если _isRetrying true, показываем мини-спиннер вместо иконки обновления
  icon: _isRetrying
      ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white, // Цвет крутилки (подстрой под свой дизайн)
          ),
        )
      : const Icon(Icons.refresh),
  label: Text("auth.retry".tr()),
  // Если _isRetrying true, передаем null — кнопка автоматически станет серой и неактивной
  onPressed: _isRetrying ? null : _retryConnection,
),           ] 
          ) 
        )
      )
    );
  }

}
