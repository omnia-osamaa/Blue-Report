import 'package:dio/dio.dart';
import 'package:general_app/core/api/api_consumer.dart';
import 'package:general_app/core/errors/exceptions.dart';

abstract class NationalIdRemoteDataSource {
  Future<Map<String, String>> extractNationalId({required String imagePath});
}

class NationalIdRemoteDataSourceImpl implements NationalIdRemoteDataSource {
  final ApiConsumer apiConsumer;

  NationalIdRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<Map<String, String>> extractNationalId({
    required String imagePath,
  }) async {
    try {
      final fileName = imagePath.split('/').last;
      final formData = FormData.fromMap({
        'national_id_image': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
        'national_id': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
      });

      final response = await apiConsumer.post(
        '/api/user/scan-id',
        body: formData,
      );

      final data =
          (response as Map<String, dynamic>)['data']
              as Map<String, dynamic>;
      final nationalId = data['national_id']?.toString() ?? '';
      final setupToken = data['setup_token']?.toString() ?? '';

      if (nationalId.isEmpty) {
        throw ServerException(
          message: 'No ID card detected. Please try with a clearer photo.',
        );
      }

      return {'national_id': nationalId, 'setup_token': setupToken};
    } catch (e, stackTrace) {
      print('=== National ID Extraction Error ===');
      print('Error: $e');
      print('Stacktrace: $stackTrace');
      print('====================================');
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}

