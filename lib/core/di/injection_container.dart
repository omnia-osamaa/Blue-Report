import 'package:general_app/core/service/local_notification_service.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:general_app/core/api/api_consumer.dart';
import 'package:general_app/core/api/api_interceptors.dart';
import 'package:general_app/core/api/dio_consumer.dart';
import 'package:general_app/core/config/app_config.dart';
import 'package:general_app/core/network/network_info.dart';
import 'package:general_app/features/auth/data/datasources/national_id_data_source.dart';
import 'package:general_app/features/auth/data/repositories/national_id_repository_impl.dart';
import 'package:general_app/features/auth/domain/repositories/national_id_repository.dart';
import 'package:general_app/features/auth/domain/usecases/forget_password_usecase.dart';
import 'package:general_app/features/auth/domain/usecases/national_id_usecase.dart';
import 'package:general_app/features/auth/domain/usecases/reset_usecase.dart';
import 'package:general_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:general_app/features/home/report/data/datasources/report_remote_data_source.dart';
import 'package:general_app/features/home/report/data/repositories/report_repository_impl.dart';
import 'package:general_app/features/home/report/domain/repositories/report_repository.dart';
import 'package:general_app/features/home/report/domain/usecases/create_report_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_recent_activity_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_user_report_stats_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_user_stats_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/update_profile_usecase.dart';
import 'package:general_app/features/home/report/presentation/bloc/report_cubit.dart';
import 'package:general_app/features/home/report/domain/usecases/get_notifications_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/mark_notification_read_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/delete_notification_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/delete_single_notification_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_rewards_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/redeem_reward_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_points_history_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_delivery_fee_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/convert_to_cash_usecase.dart';
import 'package:general_app/features/home/report/domain/usecases/get_earn_info_usecase.dart';
import 'package:general_app/features/home/report/presentation/bloc/notification_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/reward_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/points_history_cubit.dart';
import 'package:general_app/features/onBoarding/data/datasource/onboarding_local_source.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/onBoarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onBoarding/domain/repositories/onboarding_repository.dart';
import '../../features/onBoarding/domain/usecases/complete_onboarding.dart';
import '../../features/onBoarding/domain/usecases/get_onboarding_status.dart';
import '../../features/onBoarding/presentation/bloc/onboarding_cubit.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  _initCore();
  _initOnboarding();
  _initAuth();
  _initReports();
  _initNationalId();
}

void _initCore() {
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance(
    addresses: [
      AddressCheckOption(
        uri: Uri.parse('https://google.com'),
      ),
      AddressCheckOption(
        uri: Uri.parse('https://cloudflare.com'),
      ),
    ],
  ));
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  sl.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Accept': 'application/json',
      },
    ))..interceptors.addAll([
        AuthInterceptor(
          getToken: () async =>
              sl<SharedPreferences>().getString(AppConfig.authTokenKey),
        ),
        ApiInterceptor(),
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      ]),
  );
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl<Dio>()));
  sl.registerLazySingleton(() => LocalNotificationService());
}

void _initOnboarding() {
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => CompleteOnboarding(sl()));
  sl.registerLazySingleton(() => GetOnboardingStatus(sl()));
  sl.registerFactory(() => OnboardingCubit(
        completeOnboarding: sl(),
        getOnboardingStatus: sl(),
      ));
}

void _initAuth() {
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
        forgotPasswordUseCase: sl(),
        verifyOtpUseCase: sl(),
        resetPasswordUseCase: sl(),
        updateProfileUseCase: sl(),
      ));
}

void _initReports() {
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(
      apiConsumer: sl<ApiConsumer>(),
    ),
  );
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateReportUseCase(sl()));
  sl.registerLazySingleton(() => GetUserStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentActivityUseCase(sl()));
  sl.registerLazySingleton(() => GetUserReportsUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsReadUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAllNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));
  sl.registerLazySingleton(() => GetRewardsUseCase(sl()));
  sl.registerLazySingleton(() => RedeemRewardUseCase(sl()));
  sl.registerLazySingleton(() => GetPointsHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetDeliveryFeeUseCase(sl()));
  sl.registerLazySingleton(() => ConvertToCashUseCase(sl()));
  sl.registerLazySingleton(() => GetEarnInfoUseCase(sl()));

  sl.registerFactory(() => ReportCubit(
        createReportUseCase: sl(),
        getUserStatsUseCase: sl(),
        getRecentActivityUseCase: sl(),
        getUserReportsUseCase: sl(),
      ));
  sl.registerFactory(() => NotificationCubit(
        getNotificationsUseCase: sl(),
        markNotificationReadUseCase: sl(),
        markAllNotificationsReadUseCase: sl(),
        deleteAllNotificationsUseCase: sl(),
        deleteNotificationUseCase: sl(),
      ));
  sl.registerFactory(() => RewardCubit(
        getRewardsUseCase: sl(),
        redeemRewardUseCase: sl(),
        getDeliveryFeeUseCase: sl(),
        convertToCashUseCase: sl(),
        getEarnInfoUseCase: sl(),
      ));
  sl.registerFactory(() => PointsHistoryCubit(
        getPointsHistoryUseCase: sl(),
      ));
}

void _initNationalId() {
  sl.registerLazySingleton<NationalIdRemoteDataSource>(
    () => NationalIdRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<NationalIdRepository>(
    () => NationalIdRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => ExtractNationalIdUseCase(sl()));
}
