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

  // --- PROPRIEDADES INTERNAS ---
  final String now = DateFormatter.formatDayOfWeekWithDate();
  late StreamSubscription _userSubscription;
  final Map<String, double> sampleSpending = {
    'PIX': 1200.0,
    'Cartão de Crédito': 800.0,
    'Boleto': 450.0,
    'Cartão de Débito': 60.0,
    'Vale Alimentação': 40.0,
  };

  // --- GETTERS ---
  String get formattedTotalBalance => currencyFormatter.format(totalBalance.value);
  String get formattedMonthlyIncome => currencyFormatter.format(monthlyIncome.value);
  String get formattedMonthlyExpenses => currencyFormatter.format(monthlyExpenses.value);
  // GETTER PARA O RESULTADO DO MÊS
  String get formattedMonthlyNetResult =>
      currencyFormatter.format(monthlyIncome.value - monthlyExpenses.value);
  // GETTER PARA EXIBIR O MÊS/ANO SELECIONADO
  String get formattedSelectedMonth {
    // 'MMMM' para o nome completo do mês (ex: "Setembro")
    String formatted = DateFormat('MMMM yyyy', 'pt_BR').format(selectedMonth.value);
    // Capitaliza a primeira letra
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

    final monthlyTransactions = _transactionController.transactions.where((t) {
      return t.date.year == selectedMonth.value.year &&
          t.date.month == selectedMonth.value.month;
    });

    for (var t in monthlyTransactions) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expenses += t.amount;
      }
    }
    monthlyIncome.value = income;
    monthlyExpenses.value = expenses;
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
