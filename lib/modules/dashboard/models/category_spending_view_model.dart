import 'package:flutter/material.dart';

class CategorySpendingViewModel {
  final String category;
  final double value;
  final double percentage;
  final Color color;

  const CategorySpendingViewModel({
    required this.category,
    required this.value,
    required this.percentage,
    required this.color,
  });
}
