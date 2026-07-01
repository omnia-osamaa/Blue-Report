import 'package:general_app/core/usecase/usecase.dart';
import '../repositories/national_id_repository.dart';

class ExtractNationalIdUseCase extends UseCase<Map<String, String>, ExtractNationalIdParams> {
  final NationalIdRepository repository;

  ExtractNationalIdUseCase(this.repository);

  @override
  Future<Map<String, String>> call(ExtractNationalIdParams params) async {
    return await repository.extractNationalId(imagePath: params.imagePath);
  }
}

class ExtractNationalIdParams {
  final String imagePath;
  ExtractNationalIdParams({required this.imagePath});
}
