class AccountEntity {
  final String name;
  final double balance;
  final String last4Digits;
  final String validity;
  final String accountType;

  AccountEntity({
    required this.name,
    required this.balance,
    required this.last4Digits,
    required this.validity,
    required this.accountType,
  });
}
