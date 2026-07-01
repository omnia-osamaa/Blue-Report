class AppConfig {
  static const String baseUrl = 'http://187.124.12.183:8090'; 

  static const Duration connectTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 120);

  static const String appName = 'Blue Report';
  static const String appVersion = '1.0.0';

  static const String onboardingKey = 'ONBOARDING_COMPLETE';
  static const String authTokenKey = 'AUTH_TOKEN';
  static const String userDataKey = 'USER_DATA';

  static const int defaultPageSize = 20;

  static const String imageBasePath = 'assets/images/';
  static const String iconBasePath = 'assets/icons/';
}
