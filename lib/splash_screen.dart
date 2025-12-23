import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/routes/routes.dart';
import '../../core/config/app_config.dart';
import '../../core/theme/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.onboarding);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    isDark ? AppImages.logo : AppImages.logo,
                    height: 120,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'splash_title'.tr(),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   'splash_tagline'.tr(),
                  //   textAlign: TextAlign.center,
                  //   style: theme.textTheme.bodyMedium,
                  // ),
                ],
              ),
            ),
            // Positioned(
            //   bottom: 40,
            //   left: 0,
            //   right: 0,
            //   child: Column(
            //     children: [
            //       Text(
            //         'crafted_by'.tr(),
            //         style: theme.textTheme.labelSmall,
            //       ),
            //       Text(
            //         AppConfig.developerName,
            //         style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            //       ),
            //       Text(
            //         'v${AppConfig.appVersion}',
            //         style: theme.textTheme.labelSmall?.copyWith(),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
