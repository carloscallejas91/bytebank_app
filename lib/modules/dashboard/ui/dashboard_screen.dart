import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mobile_app/modules/dashboard/widgets/balance_summary_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/category_summary_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/change_avatar_sheet.dart';
import 'package:mobile_app/modules/dashboard/widgets/credit_card_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/header_widget.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children:
                    [
                          Obx(
                            () => HeaderWidget(
                              name: controller.userName.value,
                              message: 'Bem vindo de volta!',
                              date: controller.now,
                              url: controller.userPhotoUrl.value,
                              onAvatarTap: () {
                                Get.bottomSheet(
                                  const ChangeAvatarSheet(),
                                  backgroundColor: theme.colorScheme.surface,
                                  isScrollControlled: true,
                                );
                              },
                              isAvatarLoading: controller.isAvatarLoading.value,
                            ),
                          ),
                          Obx(() {
                            if (controller.account.value != null) {
                              return CreditCardWidget(
                                controller: controller,
                                number: controller.account.value!.last4Digits,
                                validity: controller.account.value!.validity,
                                accountType:
                                    controller.account.value!.accountType,
                                balance: controller.formattedTotalBalance,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          BalanceSummaryWidget(controller: controller),
                          Obx(() {
                            if (controller.spendingByCategory.isNotEmpty) {
                              return CategorySummaryWidget(
                                title: 'Gastos por Categoria',
                                spendingData: controller.spendingByCategory,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          Obx(() {
                            if (controller.incomeByCategory.isNotEmpty) {
                              return CategorySummaryWidget(
                                title: 'Receitas por Categoria',
                                spendingData: controller.incomeByCategory,
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                        ]
                        .animate(interval: 200.ms)
                        .fadeIn(duration: 500.ms, delay: 100.ms)
                        .slideY(begin: 0.3, curve: Curves.easeOut),
              ),
            ),
          ),
        );
      },
    );
  }
}
