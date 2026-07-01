import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'blue_sentinel_channel',
            'Blue Report',
            description: 'Important updates about your reports and rewards',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) return true;

    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return iosGranted ?? false;
  }

  Future<bool> hasPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'blue_sentinel_channel',
      'Blue Report Notifications',
      channelDescription: 'Important updates about your reports and rewards',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  Future<void> showReportStatusNotification({
    required String status,
    required String reportId,
  }) async {
    final isAccepted = status.toLowerCase() == 'accepted';
    await show(
      id: reportId.hashCode,
      title: isAccepted ? '🎉 Report Accepted!' : '❌ Report Rejected',
      body: isAccepted
          ? 'Your report has been verified. Points have been added!'
          : 'Your report was not accepted. Please check the details.',
      payload: reportId,
    );
  }

  Future<void> showWelcomeNotification(String userName) async {
    await show(
      id: 0,
      title: 'Welcome back, $userName! 👋',
      body: 'Ready to make a difference today?',
    );
  }
}
