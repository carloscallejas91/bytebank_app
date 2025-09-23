import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mobile_app/modules/dashboard/widgets/balance_summary_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/credit_card_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/header_widget.dart';
import 'package:mobile_app/modules/dashboard/widgets/spending_summary_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

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
                spacing: 16,
                children: [
                  // TODO: recuperar dados do firestore
                  HeaderWidget(
                    name: 'Carlos Callejas',
                    message: 'Bem vindo de volta!',
                    date: controller.now,
                    url: 'https://randomuser.me/api/portraits/men/76.jpg',
                  ),
                  // TODO: recuperar dados do cartão do firestore
                  Obx(() => CreditCardWidget(
                    controller: controller,
                    number: '4321',
                    validity: '12/26',
                    balance: controller.formattedTotalBalance,
                    accountType: 'Conta Corrente',
                  )),
                  BalanceSummaryWidget(controller: controller,),
                  Obx(() {
                    if (controller.spendingByCategory.isNotEmpty) {
                      return SpendingSummaryWidget(
                        title: 'Gastos por Categoria',
                        spendingData: controller.spendingByCategory,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  Obx(() {
                    if (controller.incomeByCategory.isNotEmpty) {
                      return SpendingSummaryWidget(
                        title: 'Receitas por Categoria',
                        spendingData: controller.incomeByCategory,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
