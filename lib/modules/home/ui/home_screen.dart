import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/home/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final theme = Theme.of(context);

    final List<Widget> screens = [
      const Center(child: Text('Dashboard')),
      const Center(child: Text('Extrato')),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildNavigationBar(homeController, theme),
      floatingActionButton: _buildFloatingActionButton(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _buildBody(homeController, screens),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
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
    return Obx(
      () => NavigationBar(
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: controller.changePage,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        maintainBottomViewPadding: true,
        indicatorColor: theme.colorScheme.primary,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            selectedIcon: Icon(Icons.space_dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list),
            selectedIcon: Icon(Icons.view_list_outlined),
            label: 'Extrato',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return FloatingActionButton(
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
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
