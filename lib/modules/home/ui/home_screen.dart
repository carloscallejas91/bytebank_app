import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/modules/dashboard/ui/dashboard_screen.dart';
import 'package:mobile_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_app/modules/transaction_form/ui/transaction_form_sheet.dart';
import 'package:mobile_app/modules/transaction/ui/transaction_screen.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> screens = [
      const Center(child: DashboardScreen()),
      const Center(child: TransactionScreen()),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      bottomNavigationBar: _buildNavigationBar(theme),
      floatingActionButton: _buildFloatingActionButton(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _buildBody(screens),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Image.asset(AppAssets.logo, height: 50),
      ),
      backgroundColor: theme.colorScheme.surface,
      shadowColor: theme.colorScheme.shadow,
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
            tooltip: 'Sair',
            onPressed: () => controller.signOut(),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationBar(ThemeData theme) {
    final navigationBar = Obx(
      () => NavigationBar(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: controller.changePage,
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
      child: navigationBar,
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return FloatingActionButton(
      tooltip: 'Adicionar transação',
      backgroundColor: theme.colorScheme.secondary,
      elevation: 2.0,
      onPressed: () {
        Get.bottomSheet(
          TransactionFormSheet(),
          backgroundColor: Theme.of(Get.context!).colorScheme.surface,
          isScrollControlled: true,
        );
      },
      child: Icon(Icons.add, color: theme.colorScheme.onSecondary),
    );
  }

  Widget _buildBody(List<Widget> screens) {
    return Obx(() => screens[controller.selectedIndex.value]);
  }
}
