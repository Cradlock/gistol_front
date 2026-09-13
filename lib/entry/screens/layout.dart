


import 'package:app_front/core/core.dart';
import 'package:app_front/entry/domain/nav_item.dart';
import 'package:app_front/entry/widgets/nav/nav_bar_desktop.dart';
import 'package:app_front/entry/widgets/nav/nav_bar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:app_front/entry/entry.dart';

class Mainlayout extends StatelessWidget{
  
  static List<NavItem> appRoutes = [
    NavItem(
      path: "/home",
      label: "home",
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    NavItem(
      path: "/about",
      label: "about",
      icon: Icons.checklist_outlined,
      selectedIcon: Icons.checklist,
    ),
    NavItem(
      path: "/profile",
      label: "profile",
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
    ),
  ];

  final Widget child;

  const Mainlayout({super.key,required this.child});

  @override
    Widget build(BuildContext context) {
      return ResponsiveLayout(
        desktop: Scaffold(
          body: Row( 
            children: [
              NavBarDesktop(routes: appRoutes),
              Expanded(child: 
                child 
              )
            ],
          )
        ),
        mobile: Scaffold(
          body: child,
          bottomNavigationBar: NavBarMobile(routes: appRoutes),
        )
      );
    }
} 
