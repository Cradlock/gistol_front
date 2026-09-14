


import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/entry/domain/nav_item.dart';
import 'package:app_front/entry/widgets/nav/nav_bar_desktop.dart';
import 'package:app_front/entry/widgets/nav/nav_bar_mobile.dart';
import 'package:flutter/material.dart';

class Mainlayout extends StatelessWidget {
  static List<NavItem> appRoutes = [
    NavItem(
      path: "/profile",
      label: AppStrings.profile.title,
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
    ),
    NavItem(
      path: "/tasks",
      label: AppStrings.tasks.title,
      icon: Icons.checklist_outlined,
      selectedIcon: Icons.checklist,
    ),
    NavItem(
      path: "/exams",
      label: AppStrings.exams.title,
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
    ),
  ];

  final Widget child;

  const Mainlayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktop: Scaffold(
        body: Row(
          children: [
            NavBarDesktop(routes: appRoutes),
            Expanded(child: child),
          ],
        ),
      ),
      mobile: Scaffold(
        body: child,
        bottomNavigationBar: NavBarMobile(routes: appRoutes),
      ),
    );
  }
}
