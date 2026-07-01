import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/di/injection_container.dart' as di;
import 'package:general_app/features/auth/domain/entities/user.dart';
import 'package:general_app/features/auth/presentation/pages/account_created_screen_success.dart';
import 'package:general_app/features/auth/presentation/pages/forget_password_method_screen.dart';
import 'package:general_app/features/auth/presentation/pages/national_id_screen.dart';
import 'package:general_app/features/home/report/domain/entities/reward_entity.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/order_summary_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/info/terms_of_service_screen.dart';
import 'package:general_app/features/auth/presentation/pages/verify_code_screen.dart';
import 'package:general_app/features/home/report/domain/entities/report.dart';
import 'package:general_app/features/home/report/presentation/bloc/report_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/notification_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/reward_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/points_history_cubit.dart';
import 'package:general_app/features/home/report/presentation/pages/info/about_us_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/notification/notification_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/info/privacy_policy_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/report/report_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/reward_store_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/profile/edit_profile_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/home/main_layout_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/my_impact_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/report/my_report_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/points_history_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/wallet_points_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/profile/profile_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/report/report_success_screen.dart'
    show ReportSuccessScreen;
import 'package:general_app/features/onBoarding/presentation/bloc/onboarding_cubit.dart';
import 'package:general_app/features/onBoarding/presentation/pages/onboarding_page.dart';
import 'package:general_app/features/auth/presentation/pages/login_screen.dart';
import 'package:general_app/features/auth/presentation/pages/register_screen.dart';
import 'package:general_app/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:general_app/features/auth/presentation/pages/password_updated_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/report/report_details_screen.dart';
import 'package:general_app/features/home/report/presentation/pages/reward/earn_money_screen.dart';
import 'package:general_app/features/splash/presentation/pages/splash_screen.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashScreen(), settings);

      case Routes.onboarding:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<OnboardingCubit>(),
            child: const OnboardingPage(),
          ),
          settings,
        );

      case Routes.login:
        return _buildRoute(const LoginScreen(), settings);

      case Routes.register:
        return _buildRoute(const RegisterScreen(), settings);

      case Routes.forgotPasswordMethod:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          ForgotPasswordMethodScreen(
            email: args?['email'] ?? '',
            phone: args?['phone'] ?? '',
          ),
          settings,
        );

      case Routes.verifyCode:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          VerifyCodeScreen(
            email: args?['email'] ?? '',
            method: args?['method'] ?? 'email',
          ),
          settings,
        );

      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          ResetPasswordScreen(
            email: args?['email'] ?? '',
            otp: args?['otp'] ?? '',
          ),
          settings,
        );

      case Routes.passwordUpdated:
        return _buildRoute(const PasswordUpdatedScreen(), settings);

      case Routes.accountCreated:
        return _buildRoute(const AccountCreatedScreen(), settings);

      
      case Routes.nationalIdScan:
        return _buildRoute(const NationalIdScanScreen(), settings);

      case Routes.profile:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<ReportCubit>(),
            child: const ProfileScreen(),
          ),
          settings,
        );

      case Routes.editProfile:
        return _buildRoute(const EditProfileScreen(), settings);

      case Routes.home:
        final args = settings.arguments as Map<String, dynamic>?;
        final user =
            args?['user'] as User? ??
            User(id: '123', fullName: 'Test User', email: 'test@example.com');
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.sl<ReportCubit>()),
              BlocProvider(
                create: (_) => di.sl<NotificationCubit>()..loadNotifications(),
              ),
              BlocProvider(create: (_) => di.sl<PointsHistoryCubit>()),
              BlocProvider(create: (_) => di.sl<RewardCubit>()),
            ],
            child: MainLayoutScreen(user: user),
          ),
          settings,
        );

      case Routes.createReport:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<ReportCubit>(),
            child: const CreateReportScreen(),
          ),
          settings,
        );

      case Routes.myReports:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<ReportCubit>(),
            child: const MyReportsScreen(),
          ),
          settings,
        );

      case Routes.myImpact:
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.sl<ReportCubit>()),
              BlocProvider(create: (_) => di.sl<PointsHistoryCubit>()),
            ],
            child: const MyImpactScreen(),
          ),
          settings,
        );
      case Routes.walletPoints:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<ReportCubit>(),
            child: const WalletPointsScreen(),
          ),
          settings,
        );

      case Routes.pointsHistory:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<PointsHistoryCubit>(),
            child: const PointsHistoryScreen(),
          ),
          settings,
        );

      case Routes.rewardsStore:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<RewardCubit>(),
            child: const RewardsStoreScreen(),
          ),
          settings,
        );

      case Routes.earnMoney:
        return _buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => di.sl<ReportCubit>()),
              BlocProvider(create: (_) => di.sl<RewardCubit>()),
            ],
            child: const EarnMoneyScreen(),
          ),
          settings,
        );

      case Routes.reportSuccess:
        final report = settings.arguments as Report;
        return _buildRoute(ReportSuccessScreen(report: report), settings);

      case Routes.privacyPolicy:
        return _buildRoute(const PrivacyPolicyScreen(), settings);

      case Routes.termsOfService:
        return _buildRoute(const TermsOfServiceScreen(), settings);

      case Routes.aboutUs:
        return _buildRoute(const AboutUsScreen(), settings);

      case Routes.notifications:
        return _buildRoute(
          BlocProvider(
            create: (_) => di.sl<NotificationCubit>(),
            child: const NotificationsScreen(),
          ),
          settings,
        );

      case Routes.reportDetails:
        final report = settings.arguments as Report;
        return _buildRoute(ReportDetailsScreen(report: report), settings);
      case Routes.orderSummary:
        final product = settings.arguments as RewardEntity;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: di.sl<RewardCubit>(),
                child: OrderSummaryScreen(product: product),
              ),
        );

      default:
        return _buildRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
