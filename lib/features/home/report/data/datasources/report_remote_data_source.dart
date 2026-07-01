import 'dart:io';
import 'package:dio/dio.dart';
import 'package:general_app/core/api/api_consumer.dart';
import 'package:general_app/core/const/server_string.dart';
import '../models/report_model.dart';
import '../models/user_stats_model.dart';
import '../models/notification_model.dart';
import '../models/reward_model.dart';
import '../models/point_history_model.dart';
import '../models/delivery_fee_model.dart';
import '../models/earn_info_model.dart';

class RewardsResult {
  final List<RewardModel> rewards;
  final int balance;
  RewardsResult({required this.rewards, required this.balance});
}

abstract class ReportRemoteDataSource {
  Future<ReportModel> createReport({
    required File image,
    required String wasteType,
    String? description,
    String? locationName,
    String? locationDescription,
    double? latitude,
    double? longitude,
  });

  Future<List<ReportModel>> getUserReports();
  Future<UserStatsModel> getUserStats();
  Future<List<ReportModel>> getRecentActivity({int limit = 5});

  Future<List<NotificationModel>> getNotifications();
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
  Future<List<PointHistoryModel>> getPointsHistory();
  Future<DeliveryFeeModel> getRewardsDeliveryFee();
  Future<String> convertToCash({
    required int points,
    required String cashMethod,
    required String phoneNumber,
  });
  Future<EarnInfoModel> getEarnInfo();
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final ApiConsumer apiConsumer;

  ReportRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ReportModel> createReport({
    required File image,
    required String wasteType,
    String? description,
    String? locationName,
    String? locationDescription,
    double? latitude,
    double? longitude,
  }) async {
    final formData = FormData.fromMap({
      'waste_type': wasteType,
      if (description != null) 'description': description,
      if (locationName != null) 'location_text': locationName,
      if (locationDescription != null) 'admin_note': locationDescription,
      if (latitude != null) 'lat': latitude,
      if (longitude != null) 'lng': longitude,
      'image': await MultipartFile.fromFile(image.path),
    });

    final response = await apiConsumer.post(
      ServerStrings.createReport,
      body: formData,
    );

    final responseData = (response as Map<String, dynamic>)['data'];
    
    Map<String, dynamic> reportData;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('report')) {
        reportData = responseData['report'] as Map<String, dynamic>;
      } else {
        reportData = responseData;
      }
    } else {
      throw Exception('Unexpected response format for report data');
    }
    
    return ReportModel.fromJson(reportData);
  }

  @override
  Future<List<ReportModel>> getUserReports() async {
    final response = await apiConsumer.get(ServerStrings.userReports);
    if (response is! Map<String, dynamic>) return [];

    final dataField = response['data'];
    List<dynamic> data;
    if (dataField is Map<String, dynamic>) {
      data = (dataField['reports'] as List?) ?? [];
    } else if (dataField is List) {
      data = dataField;
    } else {
      data = [];
    }

    return data
        .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserStatsModel> getUserStats() async {
    final response = await apiConsumer.get(ServerStrings.myImpact);
    if (response is! Map<String, dynamic>) {
      return UserStatsModel(
        totalReports: 0, totalPoints: 0, pointsToNextLevel: 100,
        currentLevel: 1, badgeTitle: 'Beginner', impactScore: 0,
      );
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      return UserStatsModel(
        totalReports: 0, totalPoints: 0, pointsToNextLevel: 100,
        currentLevel: 1, badgeTitle: 'Beginner', impactScore: 0,
      );
    }

    return UserStatsModel.fromJson(data);
  }

  @override
  Future<List<ReportModel>> getRecentActivity({int limit = 5}) async {
    final response = await apiConsumer.get(ServerStrings.userReports);
    if (response is! Map<String, dynamic>) return [];

    final dataField = response['data'];
    List<dynamic> data;
    if (dataField is Map<String, dynamic>) {
      data = (dataField['reports'] as List?) ?? [];
    } else if (dataField is List) {
      data = dataField;
    } else {
      data = [];
    }

    return data
        .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
        .toList()
        .take(limit)
        .toList();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await apiConsumer.get(ServerStrings.notifications);
    if (response is! Map<String, dynamic>) return [];

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final notifications = data['notifications'];
      if (notifications is List) {
        return notifications
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await apiConsumer.post(ServerStrings.markNotificationRead(id));
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await apiConsumer.post(ServerStrings.markAllNotificationsRead);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await apiConsumer.delete(ServerStrings.deleteAllNotifications);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await apiConsumer.delete(ServerStrings.deleteNotification(id));
  }

  @override
  Future<void> updateFcmToken(String token) async {
    await apiConsumer.post(
      ServerStrings.updateFcmToken,
      body: {'fcm_token': token},
    );
  }

  @override
  Future<RewardsResult> getRewards() async {
    final response = await apiConsumer.get(ServerStrings.rewards);
    if (response is! Map<String, dynamic>) {
      return RewardsResult(rewards: [], balance: 0);
    }

    final data = response['data'];
    if (data is Map<String, dynamic>) {
      final balance = int.tryParse(data['balance']?.toString() ?? '0') ?? 0;
      final rewardsList = data['rewards'];
      if (rewardsList is List) {
        return RewardsResult(
          rewards: rewardsList
              .map((e) => RewardModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          balance: balance,
        );
      }
      return RewardsResult(rewards: [], balance: balance);
    }
    return RewardsResult(rewards: [], balance: 0);
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
    await apiConsumer.post(
      ServerStrings.redeemReward(id),
      body: {
        'redemption_type': 'delivery',
        'full_name': fullName,
        'phone_number': phoneNumber,
        'street_address': streetAddress,
        'city': city,
        'governorate': governorate,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
  }

  @override
  Future<List<PointHistoryModel>> getPointsHistory() async {
    final response = await apiConsumer.get(ServerStrings.pointsHistory);
    if (response is! Map<String, dynamic>) return [];

    final data = response['data'];
    if (data is List) {
      return data
          .map((e) => PointHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<DeliveryFeeModel> getRewardsDeliveryFee() async {
    final response = await apiConsumer.post(ServerStrings.rewardsDeliveryFee);
    final data = (response as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return DeliveryFeeModel.fromJson(data);
  }

  @override
  Future<String> convertToCash({
    required int points,
    required String cashMethod,
    required String phoneNumber,
  }) async {
    final response = await apiConsumer.post(
      ServerStrings.convertToCash,
      body: {
        'points': points.toString(),
        'cash_method': cashMethod,
        'phone_number': phoneNumber,
      },
    );
    return (response as Map<String, dynamic>)['message'] as String? ?? 'Points converted to cash successfully!';
  }

  @override
  Future<EarnInfoModel> getEarnInfo() async {
    final response = await apiConsumer.get(ServerStrings.earnInfo);
    final data = (response as Map<String, dynamic>)['data'];
    return EarnInfoModel.fromJson(data);
  }
}
