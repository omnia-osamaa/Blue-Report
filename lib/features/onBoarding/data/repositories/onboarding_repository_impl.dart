import 'package:general_app/core/errors/failure.dart';
import 'package:general_app/features/onBoarding/data/datasource/onboarding_local_source.dart';

import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<void> completeOnboarding() async {
    try {
      await localDataSource.cacheOnboardingComplete();
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to save onboarding completion status.',
      );
    }
  }

  @override
  Future<bool> getOnboardingStatus() async {
    try {
      return await localDataSource.getOnboardingComplete();
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to retrieve onboarding status.',
      );
    }
  }
}
