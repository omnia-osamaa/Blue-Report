import '../entities/earn_info_entity.dart';
import '../repositories/report_repository.dart';

class GetEarnInfoUseCase {
  final ReportRepository repository;

  GetEarnInfoUseCase(this.repository);

  Future<EarnInfoEntity> call() async {
    return await repository.getEarnInfo();
  }
}

