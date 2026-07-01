import 'package:equatable/equatable.dart';


class UserStats extends Equatable {
  final int totalReports;
  final int totalPoints;
  final int pointsToNextLevel;
  final int currentLevel;
  final String badgeTitle;
  final double impactScore;

  const UserStats({
    required this.totalReports,
    required this.totalPoints,
    required this.pointsToNextLevel,
    required this.currentLevel,
    required this.badgeTitle,
    required this.impactScore,
  });

  @override
  List<Object?> get props => [
        totalReports,
        totalPoints,
        pointsToNextLevel,
        currentLevel,
        badgeTitle,
        impactScore,
      ];

  
  double get progressToNextLevel {
    if (pointsToNextLevel <= 0) return 1.0;
    
    final progress = (1000 - pointsToNextLevel) / 1000;
    return progress.clamp(0.0, 1.0);
  }

  
  factory UserStats.empty() {
    return const UserStats(
      totalReports: 0,
      totalPoints: 0,
      pointsToNextLevel: 1000,
      currentLevel: 1,
      badgeTitle: 'Beginner',
      impactScore: 0,
    );
  }
}
