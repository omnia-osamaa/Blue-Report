import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/features/home/report/domain/usecases/delete_notification_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/delete_single_notification_usecase.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

abstract class NotificationState {}
class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  NotificationLoaded(this.notifications)
      : unreadCount = notifications.where((n) => !n.isRead).length;
}
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;
  final DeleteAllNotificationsUseCase deleteAllNotificationsUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
    required this.deleteAllNotificationsUseCase,
    required this.deleteNotificationUseCase,
  }) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    try {
      emit(NotificationLoading());
      final notifications = await getNotificationsUseCase();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    if (state is NotificationLoaded) {
      final current = (state as NotificationLoaded).notifications;
      emit(NotificationLoaded(current.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList()));
    }
    try {
      await markNotificationReadUseCase(id);
    } catch (_) {
      await loadNotifications();
    }
  }

  Future<void> markAllAsRead() async {
    if (state is NotificationLoaded) {
      final current = (state as NotificationLoaded).notifications;
      emit(NotificationLoaded(current.map((n) => n.copyWith(isRead: true)).toList()));
    }
    try {
      await markAllNotificationsReadUseCase();
    } catch (_) {
      await loadNotifications();
    }
  }

  
  Future<void> deleteAllNotifications() async {
    emit(NotificationLoaded([]));
    try {
      await deleteAllNotificationsUseCase();
    } catch (_) {
      await loadNotifications();
    }
  }

  
  Future<void> deleteNotificationLocally(String id) async {
    if (state is NotificationLoaded) {
      final current = (state as NotificationLoaded).notifications;
      
      emit(NotificationLoaded(current.where((n) => n.id != id).toList()));
    }
    try {
      await deleteNotificationUseCase(id);
    } catch (_) {
      
      await loadNotifications();
    }
  }
}
