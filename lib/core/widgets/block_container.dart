import 'package:app_front/core/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

class CardResponsive extends StatelessWidget {
  final Widget child; // Содержимое формы (инпуты, кнопки и т.д.)

  const CardResponsive({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveLayout(
      mobile: _buildCardContainer(context, colorScheme, width: double.infinity),
      tablet: _buildCardContainer(context, colorScheme, width: 440),
      desktop: _buildCardContainer(context, colorScheme, width: 480),
    );
  }

  Widget _buildCardContainer(BuildContext context, ColorScheme colorScheme, {required double width}) {
    return Center(
      child: Card(
        child: child,
      )
    );
    
  }
}
