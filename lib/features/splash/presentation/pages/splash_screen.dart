import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/di/injection_container.dart' as di;
import 'package:general_app/core/routes/app_routes.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:general_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:general_app/features/onBoarding/domain/usecases/get_onboarding_status.dart';
import 'package:general_app/features/splash/presentation/widgets/loading_border_painter.dart';
import 'package:general_app/features/splash/presentation/widgets/reveal_clipper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _borderController;
  late final AnimationController _revealController;

  late final Animation<double> _logoScale;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _revealClip;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _revealClip = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _revealController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    _borderController.repeat();

    await _navigate();
  }

  // Splash Screen Navigation Logic
  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    try {
      final authLocalDataSource = di.sl<AuthLocalDataSource>();
      final isLoggedIn = await authLocalDataSource.isLoggedIn();
      if (!mounted) return;

      if (isLoggedIn) {
        if (!mounted) return;
        await context.read<AuthCubit>().checkAuthStatus();

        final cachedUser = await authLocalDataSource.getCachedUser();
        if (!mounted) return;
        AppRouter.navigateAndRemoveUntil(
          context,
          Routes.home,
          arguments: cachedUser != null ? {'user': cachedUser} : null,
        );
        return;
      }

      final getOnboardingStatus = di.sl<GetOnboardingStatus>();
      final hasCompletedOnboarding = await getOnboardingStatus();
      if (!mounted) return;
      AppRouter.navigateAndRemoveUntil(
        context,
        hasCompletedOnboarding ? Routes.login : Routes.onboarding,
      );
    } catch (e) {
      if (!mounted) return;
      AppRouter.navigateAndRemoveUntil(context, Routes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _borderController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_logoController, _revealController]),
            builder: (context, child) {
              return Opacity(
                opacity: _fade.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    Transform.scale(
                      scale: _logoScale.value,
                      child: SizedBox(
                        width: 140.w,
                        height: 140.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipPath(
                              clipper: RevealClipper(
                                revealPercent: _revealClip.value,
                              ),
                              child: Container(
                                width: 140.w,
                                height: 140.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                            ),

                            AnimatedBuilder(
                              animation: _borderController,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: Size(140.w, 140.w),
                                  painter: LoadingBorderPainter(
                                    progress: _borderController.value,
                                    color: AppColors.primary,
                                    strokeWidth: 3.w,
                                  ),
                                );
                              },
                            ),

                            Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.scaffoldBackgroundColor,
                              ),
                              padding: EdgeInsets.all(24.w),
                              child: Image.asset(
                                isDark ? AppImages.logo : AppImages.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    SlideTransition(
                      position: _slide,
                      child: Text(
                        'Blue Report',
                        style: AppTypography.h2.copyWith(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextPrimary(isDark),
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    SlideTransition(
                      position: _slide,
                      child: Text(
                        'Protecting Our Waterways',
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 13.sp,
                          letterSpacing: 1,
                          color: AppColors.getTextSecondary(isDark),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: _logoController,
                          builder: (context, child) {
                            final offset =
                                ((_logoController.value * 3) + index) % 3;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(
                                  alpha: offset < 1 ? 0.8 : 0.2,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
