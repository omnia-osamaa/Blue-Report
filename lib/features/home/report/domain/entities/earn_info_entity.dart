class EarnInfoEntity {
  final int balance;
  final double value;
  final String currency;
  final double exchangeRate;
  final int minPoints;
  final String exchangeLabel;

  EarnInfoEntity({
    required this.balance,
    required this.value,
    required this.currency,
    required this.exchangeRate,
    required this.minPoints,
    required this.exchangeLabel,
  });
}

