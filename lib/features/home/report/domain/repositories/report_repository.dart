import 'dart:io';
import '../entities/report.dart';
import '../entities/user_stats.dart';
import '../entities/notification_entity.dart';
import '../../data/datasources/report_remote_data_source.dart';
import '../entities/point_history_entity.dart';
import '../entities/delivery_fee_entity.dart';
import '../entities/earn_info_entity.dart';


abstract class ReportRepository {
  
  Future<Report> createReport({
    required File image,
    required String wasteType,
    String? locationDescription,
    double? latitude,
    double? longitude,
    String? locationName,
    String? additionalDetails,
  });

  
  Future<List<Report>> getUserReports({
    int page = 1,
    int limit = 10,
  });

  
  Future<UserStats> getUserStats();

  
  Future<List<Report>> getRecentActivity({int limit = 5});

  Future<List<NotificationEntity>> getNotifications();
  Future<void> markNotificationRead(String id);
  Future<void> markAllNotificationsRead();
  Future<void> deleteAllNotifications();
  Future<void> deleteNotification(String id);
  Future<void> updateFcmToken(String token);

  Future<RewardsResult> getRewards();
  Future<void> redeemReward({
    required int id,
    required String fullName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String governorate,
    String? notes,
  });

  Future<List<PointHistoryEntity>> getPointsHistory();
  Future<DeliveryFeeEntity> getRewardsDeliveryFee();
  Future<String> convertToCash({
    required int points,
    required String cashMethod,
    required String phoneNumber,
  });
  Future<EarnInfoEntity> getEarnInfo();
}
