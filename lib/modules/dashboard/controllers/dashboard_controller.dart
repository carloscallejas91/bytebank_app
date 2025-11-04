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
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/calculate_dashboard_summaries_usecase.dart';
import 'package:mobile_app/domain/usecases/get_cached_avatar_path_usecase.dart';
import 'package:mobile_app/domain/usecases/get_user_stream_usecase.dart';
import 'package:mobile_app/domain/usecases/pick_image_usecase.dart';
import 'package:mobile_app/domain/usecases/save_avatar_usecase.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DashboardController extends GetxController {
  // Services
  final _snackBarService = Get.find<SnackBarService>();

  // Repositories
  final _authRepository = Get.find<IAuthRepository>();

  // Use Cases
  final _getUserStreamUseCase = Get.find<GetUserStreamUseCase>();
  final _calculateSummariesUseCase =
      Get.find<CalculateDashboardSummariesUseCase>();
  final _saveAvatarUseCase = Get.find<SaveAvatarUseCase>();
  final _getCachedAvatarPathUseCase = Get.find<GetCachedAvatarPathUseCase>();
  final _pickImageUseCase = Get.find<PickImageUseCase>();

  // Class controllers
  final _transactionController = Get.find<TransactionController>();

  // Formatters
  final currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  final now = DateFormatter.formatDayOfWeekWithDate();

  // Account and User Data
  final Rxn<AccountEntity> account = Rxn<AccountEntity>();
  final userName = ''.obs;
  final userPhotoUrl = ''.obs;
  final totalBalance = 0.0.obs;

  // Monthly Summary Data
  final selectedMonth = DateTime.now().obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpenses = 0.0.obs;
  final spendingByCategory = <String, double>{}.obs;
  final incomeByCategory = <String, double>{}.obs;

  // Visibility and Loading Controls
  final isBalanceVisible = false.obs;
  final isAvatarLoading = false.obs;

  // Formatted Reactive Variables
  final formattedTotalBalance = 'R\$ 0,00'.obs;
  final formattedMonthlyIncome = 'R\$ 0,00'.obs;
  final formattedMonthlyExpenses = 'R\$ 0,00'.obs;
  final formattedMonthlyNetResult = 'R\$ 0,00'.obs;
  final formattedSelectedMonth = ''.obs;

  // Stream Subscriptions
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AccountEntity>? _userAccountSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupFormattedValueListeners();
    _setupDataListeners();
    _updateFormattedValues();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userAccountSubscription?.cancel();
    super.onClose();
  }

  // UI Actions
  Future<void> pickAndSaveImage(ImageSource source) async {
    final localFile = await _pickImageUseCase.call(source);
    if (localFile == null) return;

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      _snackBarService.showError(
        title: 'Erro',
        message: 'Usuário não autenticado.',
      );
      return;
    }

    await _saveAvatarAndUpdateUI(localFile, userId);
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

  void toggleBalanceVisibility() {
    isBalanceVisible.toggle();
  }

  // Internal Logic & Private Methods
  void _setupFormattedValueListeners() {
    ever(totalBalance, (_) => _updateFormattedBalance());
    ever(monthlyIncome, (_) => _updateFormattedMonthlyValues());
    ever(monthlyExpenses, (_) => _updateFormattedMonthlyValues());
    ever(selectedMonth, (_) => _updateFormattedMonth());
  }

  void _updateFormattedValues() {
    _updateFormattedBalance();
    _updateFormattedMonthlyValues();
    _updateFormattedMonth();
  }

  void _updateFormattedBalance() {
    formattedTotalBalance.value = currencyFormatter.format(totalBalance.value);
  }

  void _updateFormattedMonthlyValues() {
    formattedMonthlyIncome.value = currencyFormatter.format(
      monthlyIncome.value,
    );
    formattedMonthlyExpenses.value = currencyFormatter.format(
      monthlyExpenses.value,
    );
    formattedMonthlyNetResult.value = currencyFormatter.format(
      monthlyIncome.value - monthlyExpenses.value,
    );
  }

  void _updateFormattedMonth() {
    String formatted = DateFormat(
      'MMMM yyyy',
      'pt_BR',
    ).format(selectedMonth.value);
    formattedSelectedMonth.value =
        formatted[0].toUpperCase() + formatted.substring(1);
  }

  Future<void> _saveAvatarAndUpdateUI(File localFile, String userId) async {
    isAvatarLoading.value = true;
    try {
      final savedPath = await _saveAvatarUseCase.call(
        userId: userId,
        imageFile: localFile,
      );
      userPhotoUrl.value = savedPath;
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

  void _setupDataListeners() {
    _authSubscription = _authRepository.userChanges.listen(_onAuthChanged);
    ever(_transactionController.transactions, (_) => _calculateSummaries());
    ever(selectedMonth, (_) => _calculateSummaries());
  }

  void _onAuthChanged(User? firebaseUser) {
    _userAccountSubscription?.cancel();
    if (firebaseUser != null) {
      _handleUserLogin(firebaseUser);
    } else {
      _handleUserLogout();
    }
  }

  void _handleUserLogin(User firebaseUser) {
    _loadUserAvatar(firebaseUser);
    _userAccountSubscription = _getUserStreamUseCase
        .call(firebaseUser.uid)
        .listen(_onAccountChanged);
  }

  void _handleUserLogout() {
    userName.value = '';
    userPhotoUrl.value = '';
    totalBalance.value = 0.0;
    account.value = null;
  }

  Future<void> _loadUserAvatar(User firebaseUser) async {
    final localPath = await _getCachedAvatarPathUseCase.call(
      userId: firebaseUser.uid,
    );
    userPhotoUrl.value = localPath ?? firebaseUser.photoURL ?? '';
  }

  void _onAccountChanged(AccountEntity userAccount) {
    account.value = userAccount;
    totalBalance.value = userAccount.balance;
    userName.value = userAccount.name;
  }

  void _calculateSummaries() {
    final summary = _calculateSummariesUseCase.call(
      transactions: _transactionController.transactions,
      selectedMonth: selectedMonth.value,
    );

    monthlyIncome.value = summary.monthlyIncome;
    monthlyExpenses.value = summary.monthlyExpenses;
    spendingByCategory.value = summary.spendingByCategory;
    incomeByCategory.value = summary.incomeByCategory;
  }
}
