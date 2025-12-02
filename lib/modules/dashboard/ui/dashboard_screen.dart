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
                          Obx(() => _buildHeader(context)),
                          Obx(() => _buildCreditCard(context)),
                          Obx(() => _buildBalanceSummary(context)),
                          Obx(() => _buildSpendingSummary()),
                          Obx(() => _buildIncomeSummary()),
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

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return HeaderWidget(
      name: controller.userName.value,
      message: 'Bem vindo de volta!',
      date: controller.now,
      backgroundImage: controller.avatarController.avatarImageProvider.value,
      isAvatarLoading: controller.avatarController.isAvatarLoading.value,
      onAvatarTap: () {
        Get.bottomSheet(
          ChangeAvatarSheet(
            onPickImage: controller.avatarController.pickAndSaveImage,
          ),
          backgroundColor: theme.colorScheme.surface,
          isScrollControlled: true,
        );
      },
    );
  }

  Widget _buildCreditCard(BuildContext context) {
    if (controller.account.value == null) {
      return const SizedBox.shrink();
    }
    return CreditCardWidget(
      number: controller.account.value!.last4Digits,
      validity: controller.account.value!.validity,
      accountType: controller.account.value!.accountType,
      balance: controller.formattedTotalBalance.value,
      isBalanceVisible: controller.isBalanceVisible.value,
      onToggleBalanceVisibility: controller.toggleBalanceVisibility,
    );
  }

  Widget _buildBalanceSummary(BuildContext context) {
    return BalanceSummaryWidget(
      formattedSelectedMonth:
          controller.summaryService.formattedSelectedMonth.value,
      onPreviousMonth: controller.goToPreviousMonth,
      onNextMonth: controller.goToNextMonth,
      onSelectMonth: () => controller.selectMonth(context),
      formattedMonthlyNetResult:
          controller.summaryService.formattedMonthlyNetResult.value,
      monthlyIncomeValue: controller.summaryService.monthlyIncome.value,
      monthlyExpensesValue: controller.summaryService.monthlyExpenses.value,
      currencyFormatter: controller.summaryService.currencyFormatter,
    );
  }

  Widget _buildSpendingSummary() {
    if (controller.summaryService.spendingCategories.isEmpty) {
      return const SizedBox.shrink();
    }
    return CategorySummaryWidget(
      title: 'Gastos por Categoria',
      categories: controller.summaryService.spendingCategories.toList(),
    );
  }

  Widget _buildIncomeSummary() {
    if (controller.summaryService.incomeCategories.isEmpty) {
      return const SizedBox.shrink();
    }
    return CategorySummaryWidget(
      title: 'Receitas por Categoria',
      categories: controller.summaryService.incomeCategories.toList(),
    );
  }
}
