import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/calculate_dashboard_summaries_usecase.dart';
import 'package:mobile_app/domain/usecases/get_monthly_transactions_usecase.dart';
import 'package:mobile_app/modules/dashboard/models/category_spending_view_model.dart';

class DashboardSummaryService extends GetxService {
  // Use Cases
  final _authRepository = Get.find<IAuthRepository>();
  final _calculateSummariesUseCase =
      Get.find<CalculateDashboardSummariesUseCase>();
  final _getMonthlyTransactionsUseCase =
      Get.find<GetMonthlyTransactionsUseCase>();

  // Monthly Summary Data
  final monthlyIncome = 0.0.obs;
  final monthlyExpenses = 0.0.obs;

  // Processed data for the UI
  final spendingCategories = <CategorySpendingViewModel>[].obs;
  final incomeCategories = <CategorySpendingViewModel>[].obs;

  // Formatted Outputs
  final formattedMonthlyIncome = 'R\$ 0,00'.obs;
  final formattedMonthlyExpenses = 'R\$ 0,00'.obs;
  final formattedMonthlyNetResult = 'R\$ 0,00'.obs;
  final formattedSelectedMonth = ''.obs;

  // Formatter
  final currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  // Category Colors
  static const List<Color> _categoryColors = [
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.teal,
    Colors.redAccent,
    Colors.indigoAccent,
  ];

  @override
  void onInit() {
    super.onInit();

    _setupFormattedValueListeners();
  }

  // UI Actions
  Future<void> fetchAndCalculateSummaries(DateTime month) async {
    final user = _authRepository.currentUser;
    if (user == null) return;

    final transactions = await _getMonthlyTransactionsUseCase.call(
      userId: user.uid,
      selectedMonth: month,
    );

    final summary = _calculateSummariesUseCase.call(
      transactions: transactions,
      selectedMonth: month,
    );

    monthlyIncome.value = summary.monthlyIncome;
    monthlyExpenses.value = summary.monthlyExpenses;

    spendingCategories.value = _processCategoryData(
      summary.spendingByCategory,
      totalValue: summary.monthlyExpenses,
    );

    incomeCategories.value = _processCategoryData(
      summary.incomeByCategory,
      totalValue: summary.monthlyIncome,
    );

    _updateFormattedMonth(month);
  }

  // Internal Logic & Private Methods
  void _setupFormattedValueListeners() {
    ever(monthlyIncome, (_) => _updateFormattedMonthlyValues());
    ever(monthlyExpenses, (_) => _updateFormattedMonthlyValues());
  }

  void _updateFormattedMonth(DateTime month) {
    String formatted = DateFormat('MMMM yyyy', 'pt_BR').format(month);
    formattedSelectedMonth.value =
        formatted[0].toUpperCase() + formatted.substring(1);
  }

  void _updateFormattedMonthlyValues() {
    formattedMonthlyIncome.value = currencyFormatter.format(
      monthlyIncome.value,
    );
    formattedMonthlyExpenses.value = currencyFormatter.format(
      monthlyExpenses.value,
    );
    final netResult = monthlyIncome.value - monthlyExpenses.value;
    formattedMonthlyNetResult.value = currencyFormatter.format(netResult);
  }

  List<CategorySpendingViewModel> _processCategoryData(
    Map<String, double> data, {
    required double totalValue,
    double threshold = 0.03,
  }) {
    if (data.isEmpty || totalValue <= 0) return [];
    final groupedData = _groupCategories(data, totalValue, threshold);
    final sortedEntries = _sortGroupedCategories(groupedData);
    return _mapEntriesToViewModels(sortedEntries, totalValue);
  }

  Map<String, double> _groupCategories(
    Map<String, double> data,
    double totalValue,
    double threshold,
  ) {
    return data.entries.fold<Map<String, double>>({}, (map, entry) {
      if ((entry.value / totalValue) < threshold) {
        map['Outros'] = (map['Outros'] ?? 0) + entry.value;
      } else {
        map[entry.key] = entry.value;
      }
      return map;
    });
  }

  List<MapEntry<String, double>> _sortGroupedCategories(
    Map<String, double> groupedData,
  ) {
    return groupedData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  List<CategorySpendingViewModel> _mapEntriesToViewModels(
    List<MapEntry<String, double>> sortedEntries,
    double totalValue,
  ) {
    return sortedEntries.asMap().entries.map((indexedEntry) {
      final index = indexedEntry.key;
      final entry = indexedEntry.value;
      return CategorySpendingViewModel(
        category: entry.key,
        value: entry.value,
        percentage: entry.value / totalValue,
        color: _categoryColors[index % _categoryColors.length],
      );
    }).toList();
  }
}
