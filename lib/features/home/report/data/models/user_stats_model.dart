import '../../domain/entities/user_stats.dart';


class UserStatsModel extends UserStats {
  const UserStatsModel({
    required super.totalReports,
    required super.totalPoints,
    required super.pointsToNextLevel,
    required super.currentLevel,
    required super.badgeTitle,
    required super.impactScore,
  });

  
  
  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    final level = json['level'] is int
        ? json['level']
        : int.tryParse(json['level'].toString()) ?? 1;
    
    final balance = json['balance'] is int
        ? json['balance']
        : int.tryParse(json['balance']?.toString() ?? '0') ?? 0;
    final totalReports = json['total_reports'] is int
        ? json['total_reports']
        : int.tryParse(json['total_reports'].toString()) ?? 0;
    final acceptedReports = json['accepted_reports'] is int
        ? json['accepted_reports']
        : int.tryParse(json['accepted_reports'].toString()) ?? 0;

    
    final pointsToNextLevel = (level * 1000) - balance;

    
    final badgeTitle = _getBadgeTitle(level);

    return UserStatsModel(
      totalReports: totalReports,
      totalPoints: balance,
      pointsToNextLevel: pointsToNextLevel > 0 ? pointsToNextLevel : 0,
      currentLevel: level,
      badgeTitle: badgeTitle,
      impactScore: (acceptedReports * 50).toDouble(),
    );
  }

  static String _getBadgeTitle(int level) {
    switch (level) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Explorer';
      case 3:
        return 'Guardian';
      case 4:
        return 'Eco Warrior';
      case 5:
        return 'Champion';
      default:
        return level > 5 ? 'Legend' : 'Beginner';
    }
  }

  
  Map<String, dynamic> toJson() {
    return {
      'balance': totalPoints,
      'level': currentLevel,
      'total_reports': totalReports,
    };
  }

  
  factory UserStatsModel.fromEntity(UserStats stats) {
    return UserStatsModel(
      totalReports: stats.totalReports,
      totalPoints: stats.totalPoints,
      pointsToNextLevel: stats.pointsToNextLevel,
      currentLevel: stats.currentLevel,
      badgeTitle: stats.badgeTitle,
      impactScore: stats.impactScore,
    );
  }
}
