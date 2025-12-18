import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/domain/entities/account_entity.dart';

class AccountDataModel extends AccountEntity {
  AccountDataModel({
    required super.name,
    required super.balance,
    required super.last4Digits,
    required super.validity,
    required super.accountType,
  });

  factory AccountDataModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AccountDataModel(
      name: data['name'] ?? 'Usuário',
      balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
      last4Digits: data['account_last4'] ?? '0000',
      validity: data['account_validity'] ?? '00/00',
      accountType: data['account_type'] ?? 'Conta Indefinida',
    );
  }

  // Factory para criar a partir de um JSON (para o cache)
  factory AccountDataModel.fromJson(Map<String, dynamic> json) {
    return AccountDataModel(
      name: json['name'] ?? 'Usuário',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      last4Digits: json['account_last4'] ?? '0000',
      validity: json['account_validity'] ?? '00/00',
      accountType: json['account_type'] ?? 'Conta Indefinida',
    );
  }

  // Método para converter para JSON (para salvar no cache)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'balance': balance,
      'account_last4': last4Digits,
      'account_validity': validity,
      'account_type': accountType,
    };
  }
}
