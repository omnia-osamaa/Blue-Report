import '../entities/point_history_entity.dart';
import '../repositories/report_repository.dart';

class GetPointsHistoryUseCase {
  final ReportRepository repository;

  GetPointsHistoryUseCase(this.repository);

  Future<List<PointHistoryEntity>> call() async {
    return await repository.getPointsHistory();
  }
}

