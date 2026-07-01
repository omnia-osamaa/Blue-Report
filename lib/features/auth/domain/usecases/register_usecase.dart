import 'package:general_app/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<User> call(RegisterParams params) async {
    if (params.fullName.length < 3) throw Exception('Full name must be at least 3 characters');
    if (!_isValidEmail(params.email)) throw Exception('Invalid email format');
    if (!_isValidPhone(params.phoneNumber)) throw Exception('Invalid phone number');
    if (params.password.length < 6) throw Exception('Password must be at least 6 characters');

    return await repository.register(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      nationalId: params.nationalId,
      password: params.password,
      imagePath: params.imagePath,
      setupToken: params.setupToken,
    );
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

  bool _isValidPhone(String phone) =>
      RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone.replaceAll(RegExp(r'[\s-]'), ''));
}

class RegisterParams {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String nationalId;
  final String password;
  final String? imagePath;
  final String? setupToken;

  RegisterParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.nationalId,
    required this.password,
    this.imagePath,
    this.setupToken,
  });
}
