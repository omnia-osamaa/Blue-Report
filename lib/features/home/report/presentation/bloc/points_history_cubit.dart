import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/point_history_entity.dart';
import '../../domain/usecases/get_points_history_usecase.dart';

abstract class PointsHistoryState {}

class PointsHistoryInitial extends PointsHistoryState {}
class PointsHistoryLoading extends PointsHistoryState {}
class PointsHistoryLoaded extends PointsHistoryState {
  final List<PointHistoryEntity> history;
  PointsHistoryLoaded(this.history);
}
class PointsHistoryError extends PointsHistoryState {
  final String message;
  PointsHistoryError(this.message);
}

class PointsHistoryCubit extends Cubit<PointsHistoryState> {
  final GetPointsHistoryUseCase getPointsHistoryUseCase;

  PointsHistoryCubit({
    required this.getPointsHistoryUseCase,
  }) : super(PointsHistoryInitial());

  Future<void> loadHistory() async {
    try {
      emit(PointsHistoryLoading());
      final history = await getPointsHistoryUseCase();
      emit(PointsHistoryLoaded(history));
    } catch (e) {
      emit(PointsHistoryError(e.toString()));
    }
  }
}

