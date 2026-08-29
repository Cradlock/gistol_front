


import 'package:flutter/material.dart';
import 'spinner.dart';

class LoaderWrapper extends StatelessWidget{
  final ValueNotifier<bool> loading;
  final Widget child;
  final Widget Function()? loadingBuilder;


  const LoaderWrapper({
    super.key,
    required this.loading,
    required this.child,
    this.loadingBuilder,
  });
  
  @override
    Widget build(BuildContext context) {
      return ValueListenableBuilder(
        valueListenable: loading,
        builder: (context,isLoading,cachedChild) {
          if(isLoading) return loadingBuilder?.call() ?? const StandardSpinner();
          
          return cachedChild!;
        },
        child: child,
      ); 
    }

}
