import 'package:general_app/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class LoginUseCase extends UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<User> call(LoginParams params) async {
    if (params.email.isEmpty) {
      throw Exception('Email is required');
    }

    if (!_isValidEmail(params.email)) {
      throw Exception('Invalid email format');
    }

    if (params.password.isEmpty) {
      throw Exception('Password is required');
    }

    if (params.password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}

