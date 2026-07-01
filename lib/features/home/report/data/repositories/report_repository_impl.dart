import 'dart:io';
import '../../domain/entities/report.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/point_history_entity.dart';
import '../../domain/entities/delivery_fee_entity.dart';
import '../../domain/entities/earn_info_entity.dart';


class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Report> createReport({
    required File image,
    required String wasteType,
    String? locationDescription,
    double? latitude,
    double? longitude,
    String? locationName,
    String? additionalDetails,
  }) async {
    return await remoteDataSource.createReport(
      image: image,
      wasteType: wasteType,
      description: additionalDetails,
      locationName: locationName,
      locationDescription: locationDescription,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  Future<List<Report>> getUserReports({
    int page = 1,
    int limit = 10,
  }) async {
    return await remoteDataSource.getUserReports();
  }

  @override
  Future<UserStats> getUserStats() async {
    return await remoteDataSource.getUserStats();
  }

  @override
  Future<List<Report>> getRecentActivity({int limit = 5}) async {
    return await remoteDataSource.getRecentActivity(limit: limit);
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    return await remoteDataSource.getNotifications();
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await remoteDataSource.markNotificationRead(id);
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await remoteDataSource.markAllNotificationsRead();
  }

  @override
  Future<void> deleteAllNotifications() async {
    await remoteDataSource.deleteAllNotifications();
  }

  @override
  Future<void> deleteNotification(String id) async {
    await remoteDataSource.deleteNotification(id);
  }

  @override
  Future<void> updateFcmToken(String token) async {
    await remoteDataSource.updateFcmToken(token);
  }

  @override
  Future<RewardsResult> getRewards() async {
    return await remoteDataSource.getRewards();
  }

  @override
  Future<void> redeemReward({
    required int id,
    required String fullName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String governorate,
    String? notes,
  }) async {
    await remoteDataSource.redeemReward(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      streetAddress: streetAddress,
      city: city,
      governorate: governorate,
      notes: notes,
    );
  }

  @override
  Future<List<PointHistoryEntity>> getPointsHistory() async {
    return await remoteDataSource.getPointsHistory();
  }

  @override
  Future<DeliveryFeeEntity> getRewardsDeliveryFee() async {
    return await remoteDataSource.getRewardsDeliveryFee();
  }

  @override
  Future<String> convertToCash({
    required int points,
    required String cashMethod,
    required String phoneNumber,
  }) async {
    return await remoteDataSource.convertToCash(
      points: points,
      cashMethod: cashMethod,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<EarnInfoEntity> getEarnInfo() async {
    return await remoteDataSource.getEarnInfo();
  }
}
