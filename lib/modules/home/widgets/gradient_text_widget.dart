import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GradientTextWidget extends StatelessWidget {
  final String gradientText;

  const GradientTextWidget({super.key, required this.gradientText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientText(
      gradientText,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
    );
  }
}
