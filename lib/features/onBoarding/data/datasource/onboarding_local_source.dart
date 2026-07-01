import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/app_config.dart';

abstract class OnboardingLocalDataSource {
  Future<void> cacheOnboardingComplete();
  Future<bool> getOnboardingComplete();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences _sharedPreferences;

  OnboardingLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<void> cacheOnboardingComplete() async {
    await _sharedPreferences.setBool(AppConfig.onboardingKey, true);
  }

  @override
  Future<bool> getOnboardingComplete() async {
    return _sharedPreferences.getBool(AppConfig.onboardingKey) ?? false;
  }
}
