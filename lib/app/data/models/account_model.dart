class AccountModel {
  final String last4Digits;
  final String validity;
  final String accountType;

  AccountModel({
    this.last4Digits = '0000',
    this.validity = '00/00',
    this.accountType = 'Conta',
  });

  factory AccountModel.fromMap(Map<String, dynamic> data) {
    return AccountModel(
      last4Digits: data['account_last4'] ?? '0000',
      validity: data['account_validity'] ?? '00/00',
      accountType: data['account_type'] ?? 'Conta Corrente',
    );
  }
}