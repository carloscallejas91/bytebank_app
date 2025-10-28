class AccountEntity {
  final String last4Digits;
  final String validity;
  final String accountType;

  AccountEntity({
    this.last4Digits = '0000',
    this.validity = '00/00',
    this.accountType = 'indefinido',
  });

  factory AccountEntity.fromMap(Map<String, dynamic> data) {
    return AccountEntity(
      last4Digits: data['account_last4'] ?? '0000',
      validity: data['account_validity'] ?? '00/00',
      accountType: data['account_type'] ?? 'indefinido',
    );
  }
}
