/// Application Configuration
class AppConfig {
  AppConfig._();

  static const String appName = 'General App';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Developer Info
  static const String developerName = 'Omnia Osama';
  static const String developerGithub = 'https://github.com/AbdalluhEssam';
  static const String developerProfile = 'abdalluh-essam.com';
  static const String developerLinkedIn =
      'https://www.linkedin.com/in/abdalluh-essam';
  static const String developerEmail = 'contact@abdalluh-essam.com';

  // Environment
  static const bool isProduction = false;
  static const bool enableLogging = true;

  // API Configuration
  static String get baseUrl {
    return isProduction
        ? 'https://api.production.com'
        : 'https://api.development.com';
  }
}