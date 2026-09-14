
import 'package:app_front/entry/domain/nav_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class NavBarDesktop extends StatefulWidget {
  final List<NavItem> routes;
  
  const NavBarDesktop({required this.routes});
  
  @override
    State<StatefulWidget> createState() {
      return _NavBarDesktop();
    }
}

class _NavBarDesktop extends State<NavBarDesktop> {
  
    int _getSelectedIndex(BuildContext context){
      final String location = GoRouterState.of(context).uri.path;
      final index = widget.routes.indexWhere((item) => location.startsWith(item.path));
      return index != -1 ? index : 0;
    }

    @override
    Widget build(BuildContext context) {
      final int selectedIndex = _getSelectedIndex(context);
      final colors = Theme.of(context).colorScheme;

      return NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          context.go(widget.routes[index].path);
        },
        labelType: NavigationRailLabelType.all,
        backgroundColor: colors.surfaceContainerHigh,
        destinations: widget.routes.map((item) {
          return NavigationRailDestination(
            icon: Icon(item.icon), 
            selectedIcon: Icon(item.selectedIcon),
            label: Text(item.label.tr())
          );
        }).toList()
      );
    }

}
