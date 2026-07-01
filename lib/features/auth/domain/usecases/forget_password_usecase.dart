import 'package:general_app/core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<void> call(ForgotPasswordParams params) async {
    return await repository.sendOtp(email: params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});
}

