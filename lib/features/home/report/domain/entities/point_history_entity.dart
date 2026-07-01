class PointHistoryEntity {
  final int id;
  final int points;
  final String description;
  final String type; 
  final String createdAt;

  PointHistoryEntity({
    required this.id,
    required this.points,
    required this.description,
    required this.type,
    required this.createdAt,
  });
}

