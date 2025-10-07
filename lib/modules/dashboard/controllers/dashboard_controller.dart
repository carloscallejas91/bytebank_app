import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/data/enums/transaction_type.dart';
import 'package:mobile_app/app/data/models/account_model.dart';
import 'package:mobile_app/app/services/auth_service.dart';
import 'package:mobile_app/app/services/database_service.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class DashboardController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();
  final _authService = Get.find<AuthService>();
  final _databaseService = Get.find<DatabaseService>();

  // Class controllers
  final _transactionController = Get.find<TransactionController>();

  // Controllers
  final currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  // Models
  final account = AccountModel().obs;

  // Header
  final userName = ''.obs;
  final userPhotoUrl = ''.obs;
  final now = DateFormatter.formatDayOfWeekWithDate();

  // Credit Card
  final totalBalance = 0.0.obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpenses = 0.0.obs;

  // Resume Summary
  final selectedMonth = DateTime.now().obs;

  // Category Summary
  final spendingByCategory = <String, double>{}.obs;
  final incomeByCategory = <String, double>{}.obs;

  // Streams
  late StreamSubscription _userSubscription;

  // Conditionals
  final isBalanceVisible = false.obs;
  final isAvatarLoading = false.obs;

  //================================================================
  // Lifecycle Methods
  //================================================================

  @override
  void onInit() {
    super.onInit();

    final initialUser = _authService.currentUser;
    if (initialUser != null) {
      userName.value = initialUser.displayName ?? 'Usuário';

      account.value = AccountModel(
        last4Digits: '4321',
        validity: '12/26',
        accountType: 'Conta Corrente',
      );
    }

    _setupDataListeners();
  }

  @override
  void onClose() {
    _userSubscription.cancel();

    super.onClose();
  }

  //================================================================
  // Getters
  //================================================================

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

  //================================================================
  // Public Functions
  //================================================================

  Future<void> pickAndSaveImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) return;

    isAvatarLoading.value = true;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localFile = File(pickedFile.path);
      final fileName = p.basename(pickedFile.path);
      final savedImage = await localFile.copy('${appDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar_path', savedImage.path);

      if (userPhotoUrl.value != savedImage.path) {
        userPhotoUrl(savedImage.path);
      } else {
        userPhotoUrl.refresh();
      }

      _snackBarService.showSuccess(
        title: 'Sucesso!',
        message: 'Avatar atualizado!',
      );
    } catch (e) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Não foi possível salvar o avatar.',
      );
    } finally {
      isAvatarLoading.value = false;
    }
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

  double calculatePercentage(double value, double otherValue) {
    final maxVal = (value + otherValue);
    if (maxVal == 0) return 0.0;
    return value / maxVal;
  }

  void toggleBalanceVisibility() => isBalanceVisible.toggle();

  //================================================================
  // Private Functions
  //================================================================

  void _setupDataListeners() {
    _userSubscription = _databaseService.getUserStream().listen((userDoc) {
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>? ?? {};
        totalBalance.value = data['balance']?.toDouble() ?? 0.0;
        userName.value = data['name'] ?? 'Usuário';
        account.value = AccountModel.fromMap(data);
      }
    });

    // Worker para o usuário do Firebase Auth
    ever(_authService.user, (User? firebaseUser) {
      _loadCachedAvatar().then((localPath) {
        userPhotoUrl.value = localPath ?? firebaseUser?.photoURL ?? '';
      });
    });

    // Workers para recalcular os resumos
    ever(_transactionController.transactions, (_) => _calculateSummaries());
    ever(selectedMonth, (_) => _calculateSummaries());
  }

  Future<String?> _loadCachedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_avatar_path');
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
        incomeTotals[category] = (incomeTotals[category] ?? 0) + t.amount;
      } else {
        expenses += t.amount;
        spendingTotals[category] = (spendingTotals[category] ?? 0) + t.amount;
      }
    }

    monthlyIncome.value = income;
    monthlyExpenses.value = expenses;

    spendingByCategory.value = spendingTotals;
    incomeByCategory.value = incomeTotals;
  }
}
