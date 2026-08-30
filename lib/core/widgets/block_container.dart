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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              width: 1.0,
              color: colorScheme.outline,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
