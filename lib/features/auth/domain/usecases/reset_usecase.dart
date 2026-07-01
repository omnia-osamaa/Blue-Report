import 'package:general_app/core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<void> call(ResetPasswordParams params) async {
    return await repository.resetPassword(
      email: params.email,
      otp: params.otp,
      password: params.newPassword,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordParams({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}
