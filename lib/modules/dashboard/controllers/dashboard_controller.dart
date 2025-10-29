import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app/services/snack_bar_service.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/domain/entities/account_entity.dart';
import 'package:mobile_app/domain/enums/transaction_type.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/get_user_stream_usecase.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class DashboardController extends GetxController {
  // Services, Repositories & UseCases
  final _snackBarService = Get.find<SnackBarService>();
  final _authRepository = Get.find<IAuthRepository>();
  final _getUserStreamUseCase = Get.find<GetUserStreamUseCase>();

  // Class controllers
  final _transactionController = Get.find<TransactionController>();

  // Formatters
  final currencyFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\\\$');

  // State
  final Rxn<AccountEntity> account = Rxn<AccountEntity>();
  final userName = ''.obs;
  final userPhotoUrl = ''.obs;
  final now = DateFormatter.formatDayOfWeekWithDate();
  final totalBalance = 0.0.obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpenses = 0.0.obs;
  final selectedMonth = DateTime.now().obs;
  final spendingByCategory = <String, double>{}.obs;
  final incomeByCategory = <String, double>{}.obs;
  final isBalanceVisible = false.obs;
  final isAvatarLoading = false.obs;

  // Stream Subscriptions
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AccountEntity>? _userAccountSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupDataListeners();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userAccountSubscription?.cancel();
    super.onClose();
  }

  String get formattedTotalBalance => currencyFormatter.format(totalBalance.value);
  String get formattedMonthlyIncome => currencyFormatter.format(monthlyIncome.value);
  String get formattedMonthlyExpenses => currencyFormatter.format(monthlyExpenses.value);
  String get formattedMonthlyNetResult => currencyFormatter.format(monthlyIncome.value - monthlyExpenses.value);
  String get formattedSelectedMonth {
    String formatted = DateFormat('MMMM yyyy', 'pt_BR').format(selectedMonth.value);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

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

      userPhotoUrl.value = savedImage.path;

      _snackBarService.showSuccess(title: 'Sucesso!', message: 'Avatar atualizado!');
    } catch (e) {
      _snackBarService.showError(title: 'Erro', message: 'Não foi possível salvar o avatar.');
    } finally {
      isAvatarLoading.value = false;
    }
  }

  Future<void> selectMonth(BuildContext context) async {
    final pickedMonth = await showMonthPicker(context: context, initialDate: selectedMonth.value);
    if (pickedMonth != null && pickedMonth != selectedMonth.value) {
      selectedMonth.value = pickedMonth;
    }
  }

  void goToPreviousMonth() {
    selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month - 1);
  }

  void goToNextMonth() {
    selectedMonth.value = DateTime(selectedMonth.value.year, selectedMonth.value.month + 1);
  }

  double calculatePercentage(double value, double otherValue) {
    final maxVal = (value + otherValue);
    if (maxVal == 0) return 0.0;
    return value / maxVal;
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.toggle();
  }

  void _setupDataListeners() {
    _authSubscription = _authRepository.userChanges.listen(_onAuthChanged);

    ever(_transactionController.transactions, (_) => _calculateSummaries());
    ever(selectedMonth, (_) => _calculateSummaries());
  }

  void _onAuthChanged(User? firebaseUser) {
    _userAccountSubscription?.cancel();

    if (firebaseUser != null) {
      userName.value = firebaseUser.displayName ?? 'Usuário';
      _loadCachedAvatar().then((localPath) {
        userPhotoUrl.value = localPath ?? firebaseUser.photoURL ?? '';
      });

      _userAccountSubscription = _getUserStreamUseCase.call(firebaseUser.uid).listen(_onAccountChanged);
    } else {
      // Limpar dados do usuário ao fazer logout
      userName.value = '';
      userPhotoUrl.value = '';
      totalBalance.value = 0.0;
      account.value = null;
    }
  }

  void _onAccountChanged(AccountEntity userAccount) {
    account.value = userAccount;
    totalBalance.value = userAccount.balance;
    userName.value = userAccount.name;
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
      return t.date.year == selectedMonth.value.year && t.date.month == selectedMonth.value.month;
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
