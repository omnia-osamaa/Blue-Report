import '../entities/user_stats.dart';
import '../repositories/report_repository.dart';


class GetUserStatsUseCase {
  final ReportRepository repository;

  GetUserStatsUseCase(this.repository);

  Future<UserStats> call() async {
    return await repository.getUserStats();
  }
}
