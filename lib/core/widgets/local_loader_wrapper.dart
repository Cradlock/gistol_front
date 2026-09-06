

import 'package:app_front/core/widgets/spinner.dart';
import 'package:flutter/material.dart';

class LocalLoaderWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget Function()? loadingBuilder;

  // 1. Обычный конструктор для локального bool (например, _isLoading)
  const LocalLoaderWrapper({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingBuilder?.call() ?? const StandardSpinner();
    }
    return child;
  }
}
