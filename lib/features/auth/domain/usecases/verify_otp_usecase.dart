import 'package:general_app/core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<void, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<void> call(VerifyOtpParams params) async {
    await repository.verifyOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;

  VerifyOtpParams({required this.email, required this.otp});
}
