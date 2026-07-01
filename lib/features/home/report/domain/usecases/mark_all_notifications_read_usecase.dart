import '../repositories/report_repository.dart';

class MarkAllNotificationsReadUseCase {
  final ReportRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  Future<void> call() async {
    return await repository.markAllNotificationsRead();
  }
}

