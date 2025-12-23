import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/routes/routes.dart';
import '../../core/theme/app_images.dart';
import '../../core/theme/colors.dart';
import 'onBoarding_widget.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // البيانات مستخرجة من ملفات الـ JSON
  List<Map<String, String>> get _pages => [
        {
          'title': 'onboarding_title_1'.tr(),
          'desc': 'onboarding_desc_1'.tr(),
          'image': AppImages.onBoarding1
        },
        {
          'title': 'onboarding_title_2'.tr(),
          'desc': 'onboarding_desc_2'.tr(),
          'image': AppImages.onBoarding2
        },
        {
          'title': 'onboarding_title_3'.tr(),
          'desc': 'onboarding_desc_3'.tr(),
          'image': AppImages.onBoarding3
        },
      ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // زر تخطي (Skip)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
                child: Text('skip'.tr(), style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary)),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => OnboardingPageWidget(
                  title: _pages[index]['title']!,
                  description: _pages[index]['desc']!,
                  image: _pages[index]['image']!,
                ),
              ),
            ),

            // Footer Section (Indicators & Buttons)
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        children: [
          // النقاط المتحركة (Indicators)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8.h,
                width: _currentPage == index ? 24.w : 8.w,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFF002359) : AppColors.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // زر الاستمرار (Next/Done)
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: _onNext,
              style: theme.elevatedButtonTheme.style?.copyWith(
                backgroundColor: WidgetStateProperty.all(const Color(0xFF002359)),
              ),
              child: Text(
                _currentPage == _pages.length - 1 ? 'done'.tr() : 'next'.tr(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // زر التخطي السفلي (اختياري حسب التصميم)
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, Routes.home),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text('skip'.tr(), style: theme.textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}