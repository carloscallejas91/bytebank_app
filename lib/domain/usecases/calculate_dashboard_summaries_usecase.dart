import 'package:mobile_app/domain/entities/dashboard_summary_entity.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';

class CalculateDashboardSummariesUseCase {
  DashboardSummaryEntity call({
    required List<TransactionEntity> transactions,
    required DateTime selectedMonth,
  }) {
    double income = 0.0;
    double expenses = 0.0;
    Map<String, double> spendingTotals = {};
    Map<String, double> incomeTotals = {};

    final monthlyTransactions = transactions.where((t) {
      return t.date.year == selectedMonth.year &&
          t.date.month == selectedMonth.month;
    });

    for (var t in monthlyTransactions) {
      final category = t.paymentMethod;
      if (t.type == TransactionType.income) {
        income += t.amount;
        incomeTotals[category] = (incomeTotals[category] ?? 0) + t.amount;
      } else {
        expenses += t.amount;
        spendingTotals[category] = (spendingTotals[category] ?? 0) + t.amount;
      }
    }

    return DashboardSummaryEntity(
      monthlyIncome: income,
      monthlyExpenses: expenses,
      spendingByCategory: spendingTotals,
      incomeByCategory: incomeTotals,
    );
  }
}
