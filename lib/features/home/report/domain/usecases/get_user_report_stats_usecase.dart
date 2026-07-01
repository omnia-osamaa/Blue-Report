import '../entities/report.dart';
import '../repositories/report_repository.dart';


class GetUserReportsUseCase {
  final ReportRepository repository;

  GetUserReportsUseCase(this.repository);

  Future<List<Report>> call({int page = 1, int limit = 20}) async {
    return await repository.getUserReports(page: page, limit: limit);
  }
}
