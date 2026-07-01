class ServerStrings {
  ServerStrings._();

  static const String userLogin = '/api/user/login';
  static const String userRegister = '/api/user/register';
  static const String logout = '/api/logout';
  static const String me = '/api/me';

  static const String sendOtp = '/api/user/password/otp/send';
  static const String verifyOtp = '/api/user/password/otp/verify';
  static const String resetPassword = '/api/user/password/reset';

  static const String updateProfile = '/api/update-profile';

  static const String createReport = '/api/user/report';
  static const String userReports = '/api/user/reports';
  static const String myReports = '/api/user/reports';

  static const String pointsHistory = '/api/user/points/history';
  static const String myImpact = '/api/user/my-impact';

  static const String notifications = '/api/user/notifications';
  static const String markAllNotificationsRead =
      '/api/user/notifications/mark-all-read';
  static String markNotificationRead(String id) =>
      '/api/user/notifications/$id/read';
  static const String deleteAllNotifications = '/api/user/notifications';
  static String deleteNotification(String id) => '/api/user/notifications/$id';
  static const String updateFcmToken =
      '/api/user/notifications/update-fcm-token';

  static const String rewards = '/api/user/rewards';
  static String redeemReward(int id) => '/api/user/rewards/$id/redeem';
  static const String rewardsDeliveryFee = '/api/user/rewards/delivery-fee';
  static const String earnInfo = '/api/user/rewards/earn-info';
  static const String convertToCash = '/api/user/rewards/convert-to-cash';
}
