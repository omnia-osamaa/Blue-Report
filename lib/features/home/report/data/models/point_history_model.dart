import '../../domain/entities/point_history_entity.dart';

class PointHistoryModel extends PointHistoryEntity {
  PointHistoryModel({
    required super.id,
    required super.points,
    required super.description,
    required super.type,
    required super.createdAt,
  });

  factory PointHistoryModel.fromJson(Map<String, dynamic> json) {
    return PointHistoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      points: json['points'] is int
          ? json['points']
          : int.tryParse(json['points'].toString()) ?? 0,
      
      description:
          json['title']?.toString() ?? json['description']?.toString() ?? '',
      type: json['type']?.toString() ?? 'earned',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

