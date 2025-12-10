import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/utils/date_formatter.dart';
import 'package:mobile_app/domain/entities/account_entity.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';
import 'package:mobile_app/domain/usecases/get_user_stream_usecase.dart';
import 'package:mobile_app/modules/dashboard/controllers/avatar_controller.dart';
import 'package:mobile_app/modules/dashboard/services/dashboard_summary_service.dart';
import 'package:mobile_app/modules/transaction/controllers/transaction_controller.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DashboardController extends GetxController {
  // Repositories
  final _authRepository = Get.find<IAuthRepository>();

  // Use Cases
  final _getUserStreamUseCase = Get.find<GetUserStreamUseCase>();

  // Local Controllers and Services
  final _transactionController = Get.find<TransactionController>();
  late final DashboardSummaryService summaryService;
  late final AvatarController avatarController;

  // Formatters
  final now = DateFormatter.formatDayOfWeekWithDate();

  // Account and User Data
  final account = Rxn<AccountEntity>();
  final userName = ''.obs;
  final totalBalance = 0.0.obs;

  // Monthly Summary Data
  final selectedMonth = DateTime.now().obs;

  // UI State para avatar
  final isBalanceVisible = false.obs;

  // Formatted Reactive Variables
  final formattedTotalBalance = 'R\$ 0,00'.obs;

  // Stream Subscriptions
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<AccountEntity>? _userAccountSubscription;

  @override
  void onInit() {
    super.onInit();
    summaryService = Get.find<DashboardSummaryService>();
    avatarController = Get.find<AvatarController>();

    _setupAuthListener();
    _setupOrchestrationListeners();
    _setupFormattingListeners();

    _initialCalls();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userAccountSubscription?.cancel();

    super.onClose();
  }

  // UI Actions
  Future<void> selectMonth() async {
    final pickedMonth = await showMonthPicker(
      context: Get.context!,
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
  void _initialCalls() {
    _updateSummaries();
    _updateFormattedBalance();
  }

  void _setupAuthListener() {
    _authSubscription = _authRepository.userChanges.listen(_onAuthChanged);
  }

  void _setupOrchestrationListeners() {
    ever(_transactionController.transactions, (_) => _updateSummaries());
    ever(selectedMonth, (_) => _updateSummaries());
  }

  void _setupFormattingListeners() {
    ever(totalBalance, (_) => _updateFormattedBalance());
  }

  void _updateSummaries() {
    summaryService.calculateSummariesFor(
      _transactionController.transactions.toList(),
      selectedMonth.value,
    );
  }

  void _updateFormattedBalance() {
    formattedTotalBalance.value = summaryService.currencyFormatter.format(
      totalBalance.value,
    );
  }

  void _onAuthChanged(User? firebaseUser) {
    _userAccountSubscription?.cancel();

    if (firebaseUser != null) {
      _userAccountSubscription = _getUserStreamUseCase
          .call(firebaseUser.uid)
          .listen(_onAccountChanged);
    } else {
      _clearAccountData();
    }
  }

  void _onAccountChanged(AccountEntity userAccount) {
    account.value = userAccount;
    totalBalance.value = userAccount.balance;
    userName.value = userAccount.name;
  }

  void _clearAccountData() {
    userName.value = '';
    totalBalance.value = 0.0;
    account.value = null;
  }
}
