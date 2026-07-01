import '../repositories/report_repository.dart';

class DeleteAllNotificationsUseCase {
  final ReportRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  Future<void> call() async {
    return await repository.deleteAllNotifications();
  }
}
