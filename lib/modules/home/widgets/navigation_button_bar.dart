import 'package:flutter/material.dart';

class NavigationButtonBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) changePage;

  const NavigationButtonBar({
    super.key,
    required this.selectedIndex,
    required this.changePage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: changePage,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        maintainBottomViewPadding: true,
        backgroundColor: theme.colorScheme.primary,
        indicatorColor: theme.colorScheme.onPrimaryContainer,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard, color: theme.colorScheme.onPrimary),
            selectedIcon: Icon(
              Icons.space_dashboard_outlined,
              color: theme.colorScheme.tertiary,
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list, color: theme.colorScheme.onPrimary),
            selectedIcon: Icon(
              Icons.view_list_outlined,
              color: theme.colorScheme.tertiary,
            ),
            label: 'Extrato',
          ),
        ],
      ),
    );
  }
}
