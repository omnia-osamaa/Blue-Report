import '../entities/delivery_fee_entity.dart';
import '../repositories/report_repository.dart';

class GetDeliveryFeeUseCase {
  final ReportRepository repository;

  GetDeliveryFeeUseCase(this.repository);

  Future<DeliveryFeeEntity> call() async {
    return await repository.getRewardsDeliveryFee();
  }
}

