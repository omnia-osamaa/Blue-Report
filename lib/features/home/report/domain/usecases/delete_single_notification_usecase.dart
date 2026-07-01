import '../repositories/report_repository.dart';

class DeleteNotificationUseCase {
  final ReportRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteNotification(id);
  }
}

