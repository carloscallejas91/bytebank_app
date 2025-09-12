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
                  HeaderWidget(
                    name: 'Carlos Callejas',
                    message: 'Bem vindo de volta!',
                    date: controller.now,
                    url: 'https://randomuser.me/api/portraits/men/76.jpg',
                  ),
                  CreditCardWidget(
                    controller: controller,
                    number: '4321',
                    validity: '12/26',
                    balance: '12.555,00',
                    accountType: 'Conta Corrente',
                  ),
                  const BalanceSummaryWidget(
                    total: 7000.00,
                    income: 5000.00,
                    expenses: 2000.00,
                  ),
                  SpendingSummaryWidget(
                    spendingData: controller.sampleSpending,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
