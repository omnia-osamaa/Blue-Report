import '../repositories/report_repository.dart';

class ConvertToCashUseCase {
  final ReportRepository repository;

  ConvertToCashUseCase(this.repository);

  Future<String> call({
    required int points,
    required String cashMethod,
    required String phoneNumber,
  }) async {
    return await repository.convertToCash(
      points: points,
      cashMethod: cashMethod,
      phoneNumber: phoneNumber,
    );
  }
}

