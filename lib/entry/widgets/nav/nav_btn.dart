

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBtn extends StatelessWidget {
  final Widget icon;
  final String label;
  final String path;
  final bool isSelected;
  final Widget selectedIcon;

  const NavBtn({
    required this.icon,
    required this.label,
    required this.path,
    required this.isSelected,
    required this.selectedIcon
  });

  @override
    Widget build(BuildContext context) {
      final colors = Theme.of(context).colorScheme;
      final fonts = Theme.of(context).textTheme;


      return InkWell( 
        onTap: () => context.go(path),
        child: Padding(
          padding: const EdgeInsets.symmetric( 
            horizontal: 16,
            vertical: 8
          ),
          child: Column( 
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration( 
                border: Border(
                  top: BorderSide( 
                    color: isSelected ? colors.primary : 
                        Colors.transparent,
                    width: 3 
                  )
                ) 
              ),
              child: isSelected ? selectedIcon : icon

            ),
            const SizedBox(height: 4),
            Text(
              label,
              style:  fonts.titleSmall
            )
          ])
        ),
      ); 
    }
}
