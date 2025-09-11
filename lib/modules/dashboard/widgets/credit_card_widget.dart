import 'package:flutter/material.dart';
import 'package:mobile_app/app/ui/constants/app_assets.dart';

class CreditCardWidget extends StatelessWidget {
  final String number;
  final String validity;
  final String balance;
  final String accountType;

  const CreditCardWidget({
    super.key,
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
            _buildHeader(foreground, theme),
            _buildContent(foreground, theme, foregroundAlt),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color foreground, ThemeData theme) {
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

  Widget _buildContent(Color foreground, ThemeData theme, Color foregroundAlt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppAssets.brand, width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.visibility, color: foreground),
                    ),
                    Text(
                      'R\$ ******', // balance
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
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
