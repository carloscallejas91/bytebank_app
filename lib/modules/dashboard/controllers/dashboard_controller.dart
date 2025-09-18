import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';

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
  String get formattedTotalBalance =>
      currencyFormatter.format(totalBalance.value);

  String get formattedMonthlyIncome =>
      currencyFormatter.format(monthlyIncome.value);

  String get formattedMonthlyExpenses =>
      currencyFormatter.format(monthlyExpenses.value);

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

  void toggleBalanceVisibility() => isBalanceVisible.toggle();
}
