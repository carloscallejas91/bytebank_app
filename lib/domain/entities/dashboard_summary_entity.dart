import 'package:flutter/foundation.dart';

@immutable
class DashboardSummaryEntity {
  final double monthlyIncome;
  final double monthlyExpenses;
  final Map<String, double> spendingByCategory;
  final Map<String, double> incomeByCategory;

  const DashboardSummaryEntity({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.spendingByCategory,
    required this.incomeByCategory,
  });
}
