import '../repositories/report_repository.dart';
import '../../data/datasources/report_remote_data_source.dart';

class GetRewardsUseCase {
  final ReportRepository repository;

  GetRewardsUseCase(this.repository);

  Future<RewardsResult> call() async {
    return await repository.getRewards();
  }
}
