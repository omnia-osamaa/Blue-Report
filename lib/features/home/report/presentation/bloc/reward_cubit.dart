import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/entities/delivery_fee_entity.dart';
import '../../domain/usecases/get_rewards_usecase.dart';
import '../../domain/usecases/redeem_reward_usecase.dart';
import '../../domain/usecases/get_delivery_fee_usecase.dart';
import '../../domain/usecases/convert_to_cash_usecase.dart';
import '../../domain/usecases/get_earn_info_usecase.dart';
import '../../domain/entities/earn_info_entity.dart';

enum RewardStatus { initial, loading, loaded, success, error }

class RewardState {
  final RewardStatus status;
  final List<RewardEntity> rewards;
  final int balance;
  final DeliveryFeeEntity? deliveryFee;
  final EarnInfoEntity? earnInfo;
  final String? message;
  final String? errorMessage;

  RewardState({
    this.status = RewardStatus.initial,
    this.rewards = const [],
    this.balance = 0,
    this.deliveryFee,
    this.earnInfo,
    this.message,
    this.errorMessage,
  });

  RewardState copyWith({
    RewardStatus? status,
    List<RewardEntity>? rewards,
    int? balance,
    DeliveryFeeEntity? deliveryFee,
    EarnInfoEntity? earnInfo,
    String? message,
    String? errorMessage,
  }) {
    return RewardState(
      status: status ?? this.status,
      rewards: rewards ?? this.rewards,
      balance: balance ?? this.balance,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      earnInfo: earnInfo ?? this.earnInfo,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RewardCubit extends Cubit<RewardState> {
  final GetRewardsUseCase getRewardsUseCase;
  final RedeemRewardUseCase redeemRewardUseCase;
  final GetDeliveryFeeUseCase getDeliveryFeeUseCase;
  final ConvertToCashUseCase convertToCashUseCase;
  final GetEarnInfoUseCase getEarnInfoUseCase;

  RewardCubit({
    required this.getRewardsUseCase,
    required this.redeemRewardUseCase,
    required this.getDeliveryFeeUseCase,
    required this.convertToCashUseCase,
    required this.getEarnInfoUseCase,
  }) : super(RewardState());

  Future<void> loadRewards() async {
    if (state.status == RewardStatus.loading) return;
    try {
      emit(state.copyWith(status: RewardStatus.loading));
      final result = await getRewardsUseCase();
      emit(state.copyWith(
        status: RewardStatus.loaded,
        rewards: result.rewards,
        balance: result.balance,
      ));
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> redeemReward({
    required int id,
    required String fullName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String governorate,
    String? notes,
  }) async {
    try {
      emit(state.copyWith(status: RewardStatus.loading));
      await redeemRewardUseCase(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        streetAddress: streetAddress,
        city: city,
        governorate: governorate,
        notes: notes,
      );
      emit(state.copyWith(status: RewardStatus.success, message: 'Reward redeemed successfully!'));
      await loadRewards();
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString()));
      await loadRewards();
    }
  }

  Future<void> getDeliveryFee() async {
    if (state.status == RewardStatus.loading) return;
    try {
      emit(state.copyWith(status: RewardStatus.loading));
      final result = await getDeliveryFeeUseCase();
      emit(state.copyWith(status: RewardStatus.loaded, deliveryFee: result));
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> convertToCash({
    required int points,
    required String cashMethod,
    required String phoneNumber,
  }) async {
    try {
      emit(state.copyWith(status: RewardStatus.loading));
      final message = await convertToCashUseCase(
        points: points,
        cashMethod: cashMethod,
        phoneNumber: phoneNumber,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('The server is taking too long to respond. Please try again.'),
      );
      emit(state.copyWith(status: RewardStatus.success, message: message));
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> loadEarnInfo() async {
    try {
      emit(state.copyWith(status: RewardStatus.loading));
      final result = await getEarnInfoUseCase();
      emit(state.copyWith(status: RewardStatus.loaded, earnInfo: result));
    } catch (e) {
      emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString()));
    }
  }
}
