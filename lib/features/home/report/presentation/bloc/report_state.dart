part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}


class HomeLoaded extends ReportState {
  final UserStats stats;
  final List<Report> recentActivity;

  const HomeLoaded({required this.stats, required this.recentActivity});

  @override
  List<Object?> get props => [stats, recentActivity];
}

class HomeError extends ReportState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}


class ReportCreating extends ReportState {}

class ReportCreated extends ReportState {
  final Report report;

  const ReportCreated(this.report);

  @override
  List<Object> get props => [report];
}

class ReportCreationError extends ReportState {
  final String message;

  const ReportCreationError(this.message);

  @override
  List<Object> get props => [message];
}


class UserReportsLoaded extends ReportState {
  final List<Report> reports;

  const UserReportsLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}

class UserReportsError extends ReportState {
  final String message;

  const UserReportsError(this.message);

  @override
  List<Object> get props => [message];
}
