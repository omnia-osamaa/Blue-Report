import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_onboarding_status.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CompleteOnboarding completeOnboarding;
  final GetOnboardingStatus getOnboardingStatus;

  OnboardingCubit({
    required this.completeOnboarding,
    required this.getOnboardingStatus,
  }) : super(OnboardingInitial());

  int _currentPage = 0;

  void pageChanged(int page) {
    _currentPage = page;
    emit(OnboardingPageChanged(page));
  }

  void nextPage() {
    if (_currentPage < 2) {
      _currentPage++;
      emit(OnboardingPageChanged(_currentPage));
    }
  }

  Future<void> complete() async {
    try {
      emit(OnboardingLoading());
      await completeOnboarding();
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> skip() async {
    await complete();
  }
}
