import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';
import 'package:mobile_app/modules/dashboard/controllers/dashboard_controller.dart';

class CreditCardWidget extends StatelessWidget {
  final DashboardController controller;
  final String number;
  final String validity;
  final String balance;
  final String accountType;

  const CreditCardWidget({
    super.key,
    required this.controller,
    required this.number,
    required this.validity,
    required this.balance,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const Color background = Color(0xFF222222);
    const Color foreground = Color(0xFFFFFFFF);
    const Color foregroundAlt = Color(0xFFF1F1F1);

    return Card(
      margin: EdgeInsets.zero,
      color: background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 60,
          children: [
            _buildHeader(theme, foreground),
            _buildContent(theme, foreground, foregroundAlt),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color foreground) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.credit_card, color: foreground),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '**** $number',
              style: theme.textTheme.bodyLarge!.copyWith(
                color: foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              validity,
              style: theme.textTheme.bodySmall!.copyWith(color: foreground),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme, Color foreground, Color foregroundAlt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppAssets.brand, width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: controller.toggleBalanceVisibility,
                    icon: Icon(
                      controller.isBalanceVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: foreground,
                    ),
                  ),
                  Text(
                    controller.isBalanceVisible.value
                        ? balance
                        : 'R\$ ******',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              accountType,
              style: theme.textTheme.bodySmall!.copyWith(color: foregroundAlt),
            ),
          ],
        ),
      ],
    );
  }
}
