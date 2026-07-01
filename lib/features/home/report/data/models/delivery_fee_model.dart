import '../../domain/entities/delivery_fee_entity.dart';

class DeliveryFeeModel extends DeliveryFeeEntity {
  DeliveryFeeModel({
    required super.deliveryFee,
    required super.currency,
  });

  factory DeliveryFeeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryFeeModel(
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      currency: json['currency']?.toString() ?? 'EGP',
    );
  }
}

