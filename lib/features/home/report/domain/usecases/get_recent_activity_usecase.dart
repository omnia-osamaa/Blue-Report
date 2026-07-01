import '../entities/report.dart';
import '../repositories/report_repository.dart';


class GetRecentActivityUseCase {
  final ReportRepository repository;

  GetRecentActivityUseCase(this.repository);

  Future<List<Report>> call({int limit = 5}) async {
    return await repository.getRecentActivity(limit: limit);
  }
}
