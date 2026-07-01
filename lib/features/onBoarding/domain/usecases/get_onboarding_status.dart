import '../repositories/onboarding_repository.dart';

class GetOnboardingStatus {
  final OnboardingRepository repository;

  GetOnboardingStatus(this.repository);

  Future<bool> call() async {
    return await repository.getOnboardingStatus();
  }
}

