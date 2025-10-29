import 'package:mobile_app/domain/entities/account_entity.dart';

class AccountDataModel extends AccountEntity {
  AccountDataModel({
    required super.last4Digits,
    required super.validity,
    required super.accountType,
  });

  factory AccountDataModel.fromMap(Map<String, dynamic> data) {
    return AccountDataModel(
      last4Digits: data['account_last4'] ?? '0000',
      validity: data['account_validity'] ?? '00/00',
      accountType: data['account_type'] ?? 'indefinido',
    );
  }
}
