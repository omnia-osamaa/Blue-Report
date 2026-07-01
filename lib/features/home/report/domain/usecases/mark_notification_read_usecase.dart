import '../repositories/report_repository.dart';

class MarkNotificationReadUseCase {
  final ReportRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.markNotificationRead(id);
  }
}

