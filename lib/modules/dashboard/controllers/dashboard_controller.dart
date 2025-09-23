import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DashboardController extends GetxController {
  // --- DEPENDÊNCIAS ---
  final DatabaseService _databaseService = Get.find();
  final TransactionController _transactionController = Get.find();
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  // --- ESTADO REATIVO ---
  final RxDouble totalBalance = 0.0.obs;
  final RxDouble monthlyIncome = 0.0.obs;
  final RxDouble monthlyExpenses = 0.0.obs;
  final RxBool isBalanceVisible = false.obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  final RxMap<String, double> spendingByCategory = <String, double>{}.obs;
  final RxMap<String, double> incomeByCategory = <String, double>{}.obs;

  // --- PROPRIEDADES INTERNAS ---
  final String now = DateFormatter.formatDayOfWeekWithDate();
  late StreamSubscription _userSubscription;

  // --- GETTERS ---
  String get formattedTotalBalance =>
      currencyFormatter.format(totalBalance.value);

  String get formattedMonthlyIncome =>
      currencyFormatter.format(monthlyIncome.value);

  String get formattedMonthlyExpenses =>
      currencyFormatter.format(monthlyExpenses.value);

  String get formattedMonthlyNetResult =>
      currencyFormatter.format(monthlyIncome.value - monthlyExpenses.value);

  String get formattedSelectedMonth {
    String formatted = DateFormat(
      'MMMM yyyy',
      'pt_BR',
    ).format(selectedMonth.value);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  @override
  void onInit() {
    super.onInit();

    _listenToUserStream();
    _setupSummaryListeners();
  }

  @override
  void onClose() {
    _userSubscription.cancel();

    super.onClose();
  }

  void _setupSummaryListeners() {
    ever(_transactionController.transactions, (_) => _calculateSummaries());
    ever(selectedMonth, (_) => _calculateSummaries());
  }

  void _listenToUserStream() {
    _userSubscription = _databaseService.getUserStream().listen((userDoc) {
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        totalBalance.value = data?['balance']?.toDouble() ?? 0.0;
      }
    });
  }

  void _calculateSummaries() {
    double income = 0.0;
    double expenses = 0.0;
    Map<String, double> spendingTotals = {};
    Map<String, double> incomeTotals = {};

    final monthlyTransactions = _transactionController.transactions.where((t) {
      return t.date.year == selectedMonth.value.year &&
          t.date.month == selectedMonth.value.month;
    });

    for (var t in monthlyTransactions) {
      final category = t.paymentMethod;
      if (t.type == TransactionType.income) {
        income += t.amount;

        // Agrupa os totais de entrada por categoria
        incomeTotals[category] = (incomeTotals[category] ?? 0) + t.amount;
      } else {
        expenses += t.amount;

        // Agrupa os totais de saída por categoria
        spendingTotals[category] = (spendingTotals[category] ?? 0) + t.amount;
      }
    }

    monthlyIncome.value = income;
    monthlyExpenses.value = expenses;

    spendingByCategory.value = spendingTotals;
    incomeByCategory.value = incomeTotals;
  }

  void goToPreviousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
  }

  void goToNextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
  }

  Future<void> selectMonth(BuildContext context) async {
    final pickedMonth = await showMonthPicker(
      context: context,
      initialDate: selectedMonth.value,
    );

    if (pickedMonth != null && pickedMonth != selectedMonth.value) {
      selectedMonth.value = pickedMonth;
    }
  }

  double calculatePercentage(double value, double otherValue) {
    final maxVal = (value + otherValue);
    if (maxVal == 0) return 0.0;
    return value / maxVal;
  }

  void toggleBalanceVisibility() => isBalanceVisible.toggle();
}
