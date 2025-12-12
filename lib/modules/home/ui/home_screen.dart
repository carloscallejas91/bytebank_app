import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/modules/dashboard/ui/dashboard_screen.dart';
import 'package:mobile_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_app/modules/home/widgets/floating_button.dart';
import 'package:mobile_app/modules/home/widgets/navigation_button_bar.dart';
import 'package:mobile_app/modules/transaction/ui/transaction_screen.dart';
import 'package:mobile_app/modules/transaction_form/ui/transaction_form_sheet.dart';

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
      bottomNavigationBar: Obx(
        () => NavigationButtonBar(
          selectedIndex: controller.selectedIndex.value,
          changePage: controller.changePage,
        ),
      ),
      floatingActionButton: FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Obx(() => screens[controller.selectedIndex.value]),
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
}
