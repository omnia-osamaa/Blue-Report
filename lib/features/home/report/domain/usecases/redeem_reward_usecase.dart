import '../repositories/report_repository.dart';

class RedeemRewardUseCase {
  final ReportRepository repository;

  RedeemRewardUseCase(this.repository);

  Future<void> call({
    required int id,
    required String fullName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String governorate,
    String? notes,
  }) async {
    return await repository.redeemReward(
      id: id,
      fullName: fullName,
      phoneNumber: phoneNumber,
      streetAddress: streetAddress,
      city: city,
      governorate: governorate,
      notes: notes,
    );
  }
}

