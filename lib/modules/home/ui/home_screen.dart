import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/modules/dashboard/ui/dashboard_screen.dart';
import 'package:mobile_app/modules/home/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);

    final List<Widget> screens = [
      const Center(child: DashboardScreen()),
      const Center(child: Text('Extrato')),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      bottomNavigationBar: _buildNavigationBar(controller, theme),
      floatingActionButton: _buildFloatingActionButton(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _buildBody(controller, screens),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Image.asset(AppAssets.logo, height: 50),
      backgroundColor: theme.colorScheme.surface,
      shadowColor: theme.colorScheme.shadow,
      elevation: 2,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sair',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildNavigationBar(HomeController controller, ThemeData theme) {
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
            icon: Icon(Icons.dashboard),
            selectedIcon: Icon(Icons.space_dashboard_outlined, color: theme.colorScheme.tertiary,),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list),
            selectedIcon: Icon(Icons.view_list_outlined, color: theme.colorScheme.tertiary,),
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
      tooltip: 'Adicionar extrato',
      backgroundColor: theme.colorScheme.secondary,
      elevation: 2.0,
      onPressed: () {},
      child: Icon(Icons.add, color: theme.colorScheme.onSecondary),
    );
  }

  Widget _buildBody(HomeController controller, List<Widget> screens) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Obx(() => screens[controller.selectedIndex.value]),
            ),
          ),
        );
      },
    );
  }
}
