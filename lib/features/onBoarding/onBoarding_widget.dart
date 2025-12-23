import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أنيميشن Fade عند تغيير الصورة
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.asset(
              image,
              key: ValueKey(image),
              height: 280.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium?.copyWith(
              color: const Color(0xFF002359),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}