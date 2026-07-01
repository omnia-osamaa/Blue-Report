import '../../domain/entities/earn_info_entity.dart';

class EarnInfoModel extends EarnInfoEntity {
  EarnInfoModel({
    required super.balance,
    required super.value,
    required super.currency,
    required super.exchangeRate,
    required super.minPoints,
    required super.exchangeLabel,
  });

  factory EarnInfoModel.fromJson(Map<String, dynamic> json) {
    return EarnInfoModel(
      balance: json['balance'] is int ? json['balance'] : int.tryParse(json['balance'].toString()) ?? 0,
      value: json['value'] is double ? json['value'] : double.tryParse(json['value'].toString()) ?? 0.0,
      currency: json['currency'] ?? 'EGP',
      exchangeRate: json['exchange_rate'] is double ? json['exchange_rate'] : double.tryParse(json['exchange_rate'].toString()) ?? 0.1,
      minPoints: json['min_points'] is int ? json['min_points'] : int.tryParse(json['min_points'].toString()) ?? 500,
      exchangeLabel: json['exchange_label'] ?? '',
    );
  }
}

