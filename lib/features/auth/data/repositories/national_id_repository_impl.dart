import '../../domain/repositories/national_id_repository.dart';
import '../datasources/national_id_data_source.dart';

class NationalIdRepositoryImpl implements NationalIdRepository {
  final NationalIdRemoteDataSource dataSource;

  NationalIdRepositoryImpl({required this.dataSource});

  @override
  Future<Map<String, String>> extractNationalId({required String imagePath}) async {
    return await dataSource.extractNationalId(imagePath: imagePath);
  }
}
