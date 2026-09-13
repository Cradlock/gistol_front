


import 'package:app_front/entry/domain/nav_item.dart';
import 'package:app_front/entry/widgets/nav/nav_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class NavBarMobile extends StatelessWidget {
  final List<NavItem> routes;
  const NavBarMobile({super.key,required this.routes});

  @override
    Widget build(BuildContext context) {
      final colors = Theme.of(context).colorScheme;
      final String currentPath = GoRouterState.of(context).uri.path;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration:  BoxDecoration( 
            color: colors.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(
              Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric( 
              horizontal: 10,
              vertical: 5
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: routes.map((item) {
                return  NavBtn(
                  icon: Icon(item.icon), 
                  label: item.label, 
                  path: item.path,
                  selectedIcon: Icon(item.selectedIcon),
                  isSelected: item.path == currentPath);

              }).toList()
            )
          )
        ) 
      );
    }

}
