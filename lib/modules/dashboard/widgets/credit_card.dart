import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';

class CreditCard extends StatelessWidget {
  final String number;
  final String validity;
  final String balance;
  final String accountType;
  final bool isBalanceVisible;
  final VoidCallback onToggleBalanceVisibility;

  const CreditCard({
    super.key,
    required this.number,
    required this.validity,
    required this.balance,
    required this.accountType,
    required this.isBalanceVisible,
    required this.onToggleBalanceVisibility,
  });

  @override
  Widget build(BuildContext context) {
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
            _buildHeader(foreground),
            _buildContent(foreground, foregroundAlt),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(Color foreground) {
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
              style: Get.theme.textTheme.bodyLarge!.copyWith(
                color: foreground,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              validity,
              style: Get.theme.textTheme.bodySmall!.copyWith(color: foreground),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildContent(Color foreground, Color foregroundAlt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppAssets.brand, width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onToggleBalanceVisibility,
                  icon: Icon(
                    isBalanceVisible ? Icons.visibility_off : Icons.visibility,
                    color: foreground,
                  ),
                ),
                Text(
                  isBalanceVisible ? balance : 'R\$ ******',
                  style: Get.theme.textTheme.bodyLarge!.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              accountType,
              style: Get.theme.textTheme.bodySmall!.copyWith(
                color: foregroundAlt,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
