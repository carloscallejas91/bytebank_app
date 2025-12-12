import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mobile_app/modules/dashboard/widgets/balance_summary.dart';
import 'package:mobile_app/modules/dashboard/widgets/category_summary.dart';
import 'package:mobile_app/modules/dashboard/widgets/change_avatar_sheet.dart';
import 'package:mobile_app/modules/dashboard/widgets/credit_card.dart';
import 'package:mobile_app/modules/dashboard/widgets/header_card.dart';

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
                          _buildHeader(),
                          _buildCreditCard(),
                          _buildBalanceSummary(),
                          _buildSpendingSummary(),
                          _buildIncomeSummary(),
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

  Obx _buildHeader() {
    return Obx(
      () => HeaderCard(
        name: controller.userName.value,
        message: 'Bem vindo de volta!',
        date: controller.now,
        backgroundImage: controller.avatarController.avatarImageProvider.value,
        isAvatarLoading: controller.avatarController.isAvatarLoading.value,
        onAvatarTap: () {
          Get.bottomSheet(
            ChangeAvatarSheet(
              cameraOptionTitle: 'Tirar Foto',
              galleryOptionTitle: 'Escolher da Galeria',
              onPickImage: controller.avatarController.pickAndSaveImage,
            ),
            backgroundColor: Get.theme.colorScheme.surface,
            isScrollControlled: true,
          );
        },
      ),
    );
  }

  Obx _buildCreditCard() {
    return Obx(() {
      if (controller.account.value == null) {
        return const SizedBox.shrink();
      }

      return CreditCard(
        number: controller.account.value!.last4Digits,
        validity: controller.account.value!.validity,
        accountType: controller.account.value!.accountType,
        balance: controller.formattedTotalBalance.value,
        isBalanceVisible: controller.isBalanceVisible.value,
        onToggleBalanceVisibility: controller.toggleBalanceVisibility,
      );
    });
  }

  Obx _buildBalanceSummary() {
    return Obx(
      () => BalanceSummary(
        monthlyNetResultLabel: 'Resultado do Mês',
        incomeLabel: 'Entrada',
        expensesLabel: 'Saída',
        formattedSelectedMonth:
            controller.summaryService.formattedSelectedMonth.value,
        onPreviousMonth: controller.goToPreviousMonth,
        onNextMonth: controller.goToNextMonth,
        onSelectMonth: controller.selectMonth,
        formattedMonthlyNetResult:
            controller.summaryService.formattedMonthlyNetResult.value,
        monthlyIncomeValue: controller.summaryService.monthlyIncome.value,
        monthlyExpensesValue: controller.summaryService.monthlyExpenses.value,
        currencyFormatter: controller.summaryService.currencyFormatter,
      ),
    );
  }

  Obx _buildSpendingSummary() {
    return Obx(() {
      if (controller.summaryService.spendingCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return CategorySummary(
        title: 'Gastos por Categoria',
        categories: controller.summaryService.spendingCategories.toList(),
      );
    });
  }

  Obx _buildIncomeSummary() {
    return Obx(() {
      if (controller.summaryService.incomeCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return CategorySummary(
        title: 'Receitas por Categoria',
        categories: controller.summaryService.incomeCategories.toList(),
      );
    });
  }
}
