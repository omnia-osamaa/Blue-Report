import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:general_app/features/home/report/domain/usecases/get_user_report_stats_usecase.dart';
import '../../domain/entities/report.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/usecases/create_report_usecase.dart';
import '../../domain/usecases/get_user_stats_usecase.dart';
import '../../domain/usecases/get_recent_activity_usecase.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final CreateReportUseCase createReportUseCase;
  final GetUserStatsUseCase getUserStatsUseCase;
  final GetRecentActivityUseCase getRecentActivityUseCase;
  final GetUserReportsUseCase getUserReportsUseCase;

  UserStats? _cachedStats;

  ReportCubit({
    required this.createReportUseCase,
    required this.getUserStatsUseCase,
    required this.getRecentActivityUseCase,
    required this.getUserReportsUseCase,
  }) : super(ReportInitial());

  UserStats? get cachedStats => _cachedStats;

  Future<void> loadHomeData() async {
    try {
      if (isClosed) return;
      emit(ReportLoading());

      UserStats? stats;
      try {
        stats = await getUserStatsUseCase();
        _cachedStats = stats;
      } catch (e) {
        stats = _cachedStats ?? const UserStats(
          totalReports: 0,
          totalPoints: 0,
          pointsToNextLevel: 100,
          currentLevel: 1,
          badgeTitle: 'Beginner',
          impactScore: 0,
        );
      }

      List<Report> recentActivity = [];
      try {
        recentActivity = await getRecentActivityUseCase(limit: 5);
      } catch (e) {
        
      }

      if (isClosed) return;
      emit(HomeLoaded(stats: stats, recentActivity: recentActivity));

    } catch (e) {
      if (isClosed) return;
      emit(HomeError(e.toString()));
    }
  }

  Future<void> loadUserReports({int page = 1, int limit = 20}) async {
    try {
      if (isClosed) return;
      emit(ReportLoading());

      final reports = await getUserReportsUseCase(page: page, limit: limit);

      if (isClosed) return;
      emit(UserReportsLoaded(reports));
    } catch (e) {
      if (isClosed) return;
      emit(UserReportsError(e.toString()));
    }
  }

  Future<Report?> createReport({
    required File image,
    required String wasteType,
    String? locationDescription,
    double? latitude,
    double? longitude,
    String? locationName,
    String? additionalDetails,
  }) async {
    try {
      if (isClosed) return null;
      emit(ReportCreating());

      final report = await createReportUseCase(
        CreateReportParams(
          image: image,
          wasteType: wasteType,
          locationDescription: locationDescription,
          latitude: latitude,
          longitude: longitude,
          locationName: locationName,
          additionalDetails: additionalDetails,
        ),
      );

      if (isClosed) return report;
      emit(ReportCreated(report));
      
      return report;
    } catch (e) {
      if (isClosed) return null;
      emit(ReportCreationError(e.toString()));
      return null;
    }
  }

  Future<void> refreshHome() async {
    await loadHomeData();
  }
}
