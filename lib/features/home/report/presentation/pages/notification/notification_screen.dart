import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/features/home/report/presentation/bloc/notification_cubit.dart';
import '../../../domain/entities/notification_entity.dart';

enum _NotifType { report, points, system, warning }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    
    context.read<NotificationCubit>().loadNotifications().then((_) {
      if (mounted) {
        context.read<NotificationCubit>().markAllAsRead();
      }
    });
  }

  void _markAllRead() => context.read<NotificationCubit>().markAllAsRead();
  void _markRead(String id) => context.read<NotificationCubit>().markAsRead(id);

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Delete All', style: AppTypography.h4.copyWith(fontSize: 18.sp)),
        content: Text('Are you sure you want to delete all notifications?',
            style: AppTypography.bodyMedium.copyWith(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NotificationCubit>().deleteAllNotifications();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  _NotifType _getNotifType(String type) {
    switch (type.toLowerCase()) {
      case 'report':
      case 'status_update':
        return _NotifType.report;
      case 'points':
      case 'earned':
        return _NotifType.points;
      case 'warning':
      case 'rejected':
        return _NotifType.warning;
      default:
        return _NotifType.system;
    }
  }

  ({
    List<NotificationEntity> today,
    List<NotificationEntity> yesterday,
    List<NotificationEntity> older,
  })
  _group(List<NotificationEntity> list) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    final today = <NotificationEntity>[];
    final yesterday = <NotificationEntity>[];
    final older = <NotificationEntity>[];

    for (final n in list) {
      final raw = DateTime.tryParse(n.createdAt) ?? now;
      final date = DateTime(raw.year, raw.month, raw.day);
      if (date == todayDate) {
        today.add(n);
      } else if (date == yesterdayDate) {
        yesterday.add(n);
      } else {
        older.add(n);
      }
    }
    return (today: today, yesterday: yesterday, older: older);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            final unreadCount = state is NotificationLoaded ? state.unreadCount : 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Notifications',
                  style: AppTypography.h4.copyWith(
                    fontSize: 18.sp,
                    color: theme.textTheme.headlineMedium?.color,
                  ),
                ),
                if (unreadCount > 0) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: AppTypography.labelSmall.copyWith(fontSize: 11.sp, color: Colors.white),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is! NotificationLoaded || state.notifications.isEmpty) {
                return const SizedBox.shrink();
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  if (state.unreadCount > 0)
                    TextButton(
                      onPressed: _markAllRead,
                      child: Text(
                        'Mark all',
                        style: AppTypography.labelLarge.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  
                  IconButton(
                    onPressed: _showDeleteAllDialog,
                    icon: Icon(Icons.delete_outline, color: AppColors.error, size: 22.sp),
                    tooltip: 'Delete all',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
                  SizedBox(height: 12.h),
                  Text(state.message, style: AppTypography.bodyMedium.copyWith(fontSize: 14.sp)),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => context.read<NotificationCubit>().loadNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) return _buildEmpty(theme);

            final grouped = _group(notifications);

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              children: [
                if (grouped.today.isNotEmpty) ...[
                  _buildGroupHeader('Today', theme),
                  ...grouped.today.map((n) => _buildNotifTile(n, theme, isDark)),
                ],
                if (grouped.yesterday.isNotEmpty) ...[
                  _buildGroupHeader('Yesterday', theme),
                  ...grouped.yesterday.map((n) => _buildNotifTile(n, theme, isDark)),
                ],
                if (grouped.older.isNotEmpty) ...[
                  _buildGroupHeader('Older', theme),
                  ...grouped.older.map((n) => _buildNotifTile(n, theme, isDark)),
                ],
                SizedBox(height: 40.h),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGroupHeader(String label, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNotifTile(NotificationEntity notif, ThemeData theme, bool isDark) {
    final notifType = _getNotifType(notif.type);

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          context.read<NotificationCubit>().deleteNotificationLocally(notif.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.delete_outline, color: AppColors.error, size: 24.sp),
      ),
      child: GestureDetector(
        onTap: () => _markRead(notif.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: notif.isRead
                ? (isDark ? AppColors.surfaceDark : Colors.white)
                : (isDark
                    ? AppColors.primary.withOpacity(0.08)
                    : AppColors.primaryLight),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: notif.isRead
                  ? (isDark ? AppColors.borderDark : AppColors.border)
                  : AppColors.primary.withOpacity(0.25),
              width: notif.isRead ? 1 : 1.5,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: _notifColor(notifType, notif.color).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _notifIcon(notifType),
                  color: _notifColor(notifType, notif.color),
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 14.sp,
                              fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.bold,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notif.body,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 13.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    
                    Text(
                      notif.timeAgo ?? _timeAgo(DateTime.tryParse(notif.createdAt) ?? DateTime.now()),
                      style: AppTypography.bodySmall.copyWith(fontSize: 11.sp, color: AppColors.hintText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
            child: Icon(Icons.notifications_none_rounded, size: 48.sp, color: AppColors.primary),
          ),
          SizedBox(height: 20.h),
          Text(
            'No Notifications Yet',
            style: AppTypography.h4.copyWith(fontSize: 18.sp,
                color: theme.textTheme.headlineMedium?.color),
          ),
          SizedBox(height: 8.h),
          Text("You're all caught up!",
              style: AppTypography.bodyMedium.copyWith(fontSize: 14.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  IconData _notifIcon(_NotifType type) {
    switch (type) {
      case _NotifType.report:
        return Icons.assignment_outlined;
      case _NotifType.points:
        return Icons.stars_rounded;
      case _NotifType.system:
        return Icons.info_outline;
      case _NotifType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  Color _notifColor(_NotifType type, String? apiColor) {
    
    if (apiColor != null) {
      switch (apiColor.toLowerCase()) {
        case 'red':
          return AppColors.error;
        case 'green':
          return AppColors.success;
        case 'yellow':
        case 'orange':
          return AppColors.warning;
        case 'blue':
        default:
          return AppColors.primary;
      }
    }
    switch (type) {
      case _NotifType.report:
        return AppColors.primary;
      case _NotifType.points:
        return AppColors.warning;
      case _NotifType.system:
        return AppColors.info;
      case _NotifType.warning:
        return AppColors.error;
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
