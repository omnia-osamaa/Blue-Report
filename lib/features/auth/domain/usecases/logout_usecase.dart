import 'package:general_app/core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';


class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.logout();
  }
}

