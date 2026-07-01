import '../../domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  RewardModel({
    required super.id,
    required super.title,
    required super.description,
    required super.cost,
    super.image,
    super.isRedeemed = false,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      
      title: json['name']?.toString() ?? json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString() ?? '',
      
      cost: json['points_required'] is int
          ? json['points_required']
          : int.tryParse(json['points_required']?.toString() ?? json['cost']?.toString() ?? '0') ?? 0,
      image: json['image']?.toString(),
      isRedeemed: json['is_redeemed'] == true || json['is_redeemed'] == 1,
    );
  }
}
