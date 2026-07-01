import 'package:general_app/features/auth/domain/entities/user.dart';
import 'package:general_app/features/auth/domain/repositories/auth_repository.dart';


class UpdateProfileParams {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String nationalId;
  final String? password;
  final String? imagePath;

  const UpdateProfileParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.nationalId,
    this.password,
    this.imagePath,
  });
}

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<User> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      nationalId: params.nationalId,
      password: params.password,
      imagePath: params.imagePath,
    );
  }
}
