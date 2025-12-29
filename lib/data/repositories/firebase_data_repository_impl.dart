import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_app/data/datasources/firebase_data_source.dart';
import 'package:mobile_app/data/models/account_data_model.dart';
import 'package:mobile_app/data/models/paginated_transactions.dart';
import 'package:mobile_app/data/models/transaction_data_model.dart';
import 'package:mobile_app/domain/entities/account_entity.dart';
import 'package:mobile_app/domain/entities/transaction_entity.dart';
import 'package:mobile_app/domain/entities/transaction_filter_model.dart';
import 'package:mobile_app/domain/enums/sort_order.dart';
import 'package:mobile_app/domain/repositories/i_local_data_source.dart';
import 'package:mobile_app/domain/repositories/i_network_info.dart';
import 'package:mobile_app/domain/repositories/i_transaction_repository.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class FirebaseDataRepositoryImpl
    implements IUserRepository, ITransactionRepository {
  final FirebaseDataSource _dataSource;
  final ILocalDataSource _localDataSource;
  final INetworkInfo _networkInfo;

  FirebaseDataRepositoryImpl(
    this._dataSource,
    this._localDataSource,
    this._networkInfo,
  );

  // User Repository
  @override
  Stream<AccountEntity> getUserStream(String uid) {
    final controller = StreamController<AccountEntity>();

    // Emite o valor do cache (se existir).
    _emitCachedUserAccount(uid, controller);

    // Ouve as atualizações da rede e obtém a inscrição para poder cancelá-la depois.
    final networkSubscription = _listenToNetworkUserStream(uid, controller);

    // Gerencia o ciclo de vida da stream para evitar vazamentos de memória.
    controller.onCancel = () {
      networkSubscription.cancel();
      controller.close();
    };

    return controller.stream;
  }

  // Busca os dados do usuário no cache local e os emite na stream.
  void _emitCachedUserAccount(
    String uid,
    StreamController<AccountEntity> controller,
  ) {
    _localDataSource
        .getLastUserAccount(uid)
        .then((cachedAccount) {
          if (cachedAccount != null && !controller.isClosed) {
            controller.add(cachedAccount);
          } else {
            debugPrint("Cache estava vazio ou nulo.");
          }
        })
        .catchError((error) {
          debugPrint("Erro ao ler cache: $error");
        });
  }

  // Ouve a stream do Firestore, atualiza o cache e emite novos dados.
  StreamSubscription _listenToNetworkUserStream(
    String uid,
    StreamController<AccountEntity> controller,
  ) {
    return _dataSource
        .getUserStream(uid)
        .where((doc) => doc.exists)
        .map((doc) => AccountDataModel.fromDocument(doc))
        .listen(
          (networkAccount) {
            _localDataSource.saveUserAccount(uid, networkAccount);
            debugPrint(
              "Cache salvo: Nome=${networkAccount.name}, Saldo=${networkAccount.balance}",
            );

            if (!controller.isClosed) {
              controller.add(networkAccount);
            }
          },
          onError: (error) {
            if (!controller.isClosed) {
              controller.addError(error);
            }
          },
        );
  }

  @override
  Future<void> createUserDocument({required User user, required String name}) {
    return _dataSource.createUserDocument(user: user, name: name);
  }

  @override
  Future<void> updateUserBalance(String uid, double change) {
    return _dataSource.updateUserBalance(uid, change);
  }

  @override
  Future<String> saveAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_avatar_path_$userId', savedImage.path);

      return savedImage.path;
    } catch (e) {
      debugPrint('Falha ao salvar avatar localmente: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getCachedAvatarPath({required String userId}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('user_avatar_path_$userId');
  }

  // Transaction Repository
  @override
  Future<void> addTransaction(String userId, TransactionEntity transaction) {
    final transactionModel = TransactionDataModel.fromEntity(transaction);
    return _dataSource.addTransaction(userId, transactionModel);
  }

  @override
  Future<void> deleteTransaction(String userId, TransactionEntity transaction) {
    final transactionModel = TransactionDataModel.fromEntity(transaction);
    return _dataSource.deleteTransaction(userId, transactionModel);
  }

  @override
  Future<PaginatedTransactions> fetchTransactionsPage({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    final bool canUseCache = startAfter == null;

    if (!canUseCache) {
      return _fetchWithoutCache(
        userId: userId,
        limit: limit,
        startAfter: startAfter,
        filter: filter,
        sortOrder: sortOrder,
      );
    }

    if (await _networkInfo.isConnected) {
      return _fetchFromNetworkAndCache(
        userId: userId,
        limit: limit,
        filter: filter,
        sortOrder: sortOrder,
      );
    } else {
      return _fetchFromCache(filter: filter, sortOrder: sortOrder);
    }
  }

  // Tenta buscar da rede e, em caso de sucesso, atualiza o cache.
  // Se a busca na rede falhar (ex: timeout), usa o cache como fallback.
  Future<PaginatedTransactions> _fetchFromNetworkAndCache({
    required String userId,
    required int limit,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    try {
      final networkResult = await _dataSource.fetchTransactionsPage(
        userId: userId,
        limit: limit,
        startAfter: null,
        filter: filter,
        sortOrder: sortOrder,
      );

      if (!(filter?.isEnabled ?? false)) {
        await _localDataSource.saveTransactions(networkResult.transactions);
      }

      return networkResult;
    } catch (e) {
      return _fetchFromCache(filter: filter, sortOrder: sortOrder);
    }
  }

  // Busca os dados diretamente do armazenamento local.
  // Aplica filtros e ordenação do lado do cliente sobre os dados cacheados.
  Future<PaginatedTransactions> _fetchFromCache({
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) async {
    final allCachedTransactions = await _localDataSource.getLastTransactions();

    final filteredAndSortedTransactions = _applyClientSideFilters(
      allCachedTransactions,
      filter,
      sortOrder: sortOrder,
    );

    return PaginatedTransactions(
      transactions: filteredAndSortedTransactions,
      lastDocument: null,
    );
  }

  // Replica a lógica de filtragem e ordenação do Firebase no lado do cliente.
  // Isso permite que os filtros funcionem de forma consistente em modo offline
  List<TransactionDataModel> _applyClientSideFilters(
    List<TransactionDataModel> transactions,
    TransactionFilterModel? filter, {
    SortOrder sortOrder = SortOrder.desc,
  }) {
    final filteredTransactions = (filter == null || !filter.isEnabled)
        ? transactions
        : transactions.where((transaction) {
            if (filter.type != null && transaction.type != filter.type) {
              return false;
            }
            if (filter.startDate != null &&
                transaction.date.isBefore(filter.startDate!)) {
              return false;
            }
            if (filter.endDate != null &&
                transaction.date.isAfter(filter.endDate!)) {
              return false;
            }
            if (filter.descriptionSearch.isNotEmpty &&
                !transaction.description.toLowerCase().contains(
                  filter.descriptionSearch.toLowerCase(),
                )) {
              return false;
            }
            return true;
          }).toList();

    filteredTransactions.sort((a, b) {
      if (sortOrder == SortOrder.desc) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });

    return filteredTransactions;
  }

  // Busca transações diretamente da fonte de dados
  Future<PaginatedTransactions> _fetchWithoutCache({
    required String userId,
    required int limit,
    DocumentSnapshot? startAfter,
    TransactionFilterModel? filter,
    SortOrder sortOrder = SortOrder.desc,
  }) {
    return _dataSource.fetchTransactionsPage(
      userId: userId,
      limit: limit,
      startAfter: startAfter,
      filter: filter,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<void> updateTransaction(
    String userId,
    TransactionEntity oldTransaction,
    TransactionEntity newTransaction,
  ) {
    final oldTransactionModel = TransactionDataModel.fromEntity(oldTransaction);
    final newTransactionModel = TransactionDataModel.fromEntity(newTransaction);
    return _dataSource.updateTransaction(
      userId,
      oldTransactionModel,
      newTransactionModel,
    );
  }

  @override
  Future<List<TransactionEntity>> getTransactionsForMonth(
    String userId,
    DateTime month,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final transactionModels = await _dataSource.fetchMonthlyTransactions(
          userId: userId,
          month: month,
        );

        await _localDataSource.saveMonthlyTransactions(
          userId,
          month,
          transactionModels,
        );

        return transactionModels;
      } catch (e) {
        debugPrint('Erro ao buscar transações mensais da rede: $e');
        // Fallback para o cache em caso de erro na requisição
        return _fetchMonthlyFromCache(userId, month);
      }
    } else {
      return _fetchMonthlyFromCache(userId, month);
    }
  }

  Future<List<TransactionEntity>> _fetchMonthlyFromCache(
    String userId,
    DateTime month,
  ) async {
    final cachedModels = await _localDataSource.getMonthlyTransactions(
      userId,
      month,
    );
    return cachedModels; // TransactionDataModel is a TransactionEntity
  }
}
