import 'package:bytebank_app/domain/entities/account_entity.dart';

class AccountDataModel extends AccountEntity {
  AccountDataModel({
    required String last4Digits,
    required String validity,
    required String accountType,
  }) : super(
          last4Digits: last4Digits,
          validity: validity,
          accountType: accountType,
        );

  factory AccountDataModel.fromMap(Map<String, dynamic> data) {
    return AccountDataModel(
      last4Digits: data['account_last4'] ?? '0000',
      validity: data['account_validity'] ?? '00/00',
      accountType: data['account_type'] ?? 'Conta Corrente',
    );
  }
}
