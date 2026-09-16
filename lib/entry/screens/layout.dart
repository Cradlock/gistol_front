import 'package:app_front/core/core.dart';
import 'package:app_front/core/strings.dart';
import 'package:app_front/entry/domain/nav_item.dart';
import 'package:app_front/entry/widgets/nav/nav_bar_desktop.dart';
import 'package:app_front/entry/widgets/nav/nav_bar_mobile.dart';
import 'package:app_front/features/auth/auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final isConfirmed = context.watch<AuthProvider>().isConfirmed;

    return ResponsiveLayout(
      desktop: Scaffold(
        body: Column(
          children: [
            if (!isConfirmed) const _NotConfirmedBanner(),
            Expanded(
              child: Row(
                children: [
                  NavBarDesktop(routes: appRoutes),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
      mobile: Scaffold(
        body: Column(
          children: [
            if (!isConfirmed) const _NotConfirmedBanner(),
            Expanded(child: child),
          ],
        ),
        bottomNavigationBar: NavBarMobile(routes: appRoutes),
      ),
    );
  }
}

class _NotConfirmedBanner extends StatelessWidget {
  const _NotConfirmedBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.tertiaryContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: colors.onTertiaryContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.auth.not_confirmed_pages_blocked.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onTertiaryContainer,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
