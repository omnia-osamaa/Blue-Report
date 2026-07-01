import '../entities/notification_entity.dart';
import '../repositories/report_repository.dart';

class GetNotificationsUseCase {
  final ReportRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.getNotifications();
  }
}

