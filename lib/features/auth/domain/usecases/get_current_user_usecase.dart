import 'package:general_app/core/usecase/usecase.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class GetCurrentUserUseCase extends UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<User?> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

