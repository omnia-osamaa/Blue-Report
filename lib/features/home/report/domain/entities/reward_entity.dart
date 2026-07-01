class RewardEntity {
  final int id;
  final String title;
  final String description;
  final int cost;
  final String? image;
  final bool isRedeemed;

  RewardEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    this.image,
    this.isRedeemed = false,
  });
}

