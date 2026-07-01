import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/locolization/localization_manager.dart';
import 'package:general_app/core/routes/app_routes.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/app_theme.dart';
import 'package:general_app/core/di/injection_container.dart' as di;
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:general_app/core/widgets/responsive_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('en', null);
  await di.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      fallbackLocale: LocalizationManager.fallbackLocale,
      startLocale: LocalizationManager.fallbackLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => di.sl<AuthCubit>(),
          child: MaterialApp(
            title: 'Blue Report',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: Routes.splash,
            onGenerateRoute: AppRouter.generateRoute,
            builder: (context, child) {
              return ResponsiveWrapper(child: child!);
            },
          ),
        );
      },
    );
  }
}
