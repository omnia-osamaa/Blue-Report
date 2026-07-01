import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'bluesentinel9@gmail.com',
      queryParameters: {'subject': 'Support Request - Blue Report'},
    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Us',
          style: AppTypography.h4.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(24.w),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: Image.asset(AppImages.logo),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Blue Report',
                  style: AppTypography.h2.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Protecting Our Waterways',
                  style: AppTypography.labelLarge.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          _InfoCard(
            icon: Icons.flag_outlined,
            title: 'Our Mission',
            body:
                'Blue Report empowers communities to protect rivers and waterways by making it easy to report pollution and hold authorities accountable. Every report you submit makes a real difference.',
            isDark: isDark,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          _InfoCard(
            icon: Icons.visibility_outlined,
            title: 'Our Vision',
            body:
                'A world where every river runs clean — powered by citizen action and transparent environmental data.',
            isDark: isDark,
            theme: theme,
          ),

          SizedBox(height: 16.h),

          _InfoCard(
            icon: Icons.handshake_outlined,
            title: 'How It Works',
            body:
                'Spot pollution → Snap a photo → Submit your report → Earn points. Your reports are reviewed by our team and forwarded to the relevant environmental authorities.',
            isDark: isDark,
            theme: theme,
          ),

          SizedBox(height: 24.h),

          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: isDark ? Border.all(color: AppColors.borderDark) : null,
              boxShadow:
                  isDark
                      ? null
                      : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: AppTypography.bodyLarge.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  onTap: _launchEmail,
                  child: Text(
                    'bluesentinel9@gmail.com',
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              'Version 1.0.0',
              style: AppTypography.caption.copyWith(
                fontSize: 12.sp,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
              ),
            ),
          ),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool isDark;
  final ThemeData theme;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow:
            isDark
                ? null
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: theme.colorScheme.onPrimary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  body,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 13.sp,
                    color:
                        isDark
                            ? theme.textTheme.bodyMedium?.color?.withOpacity(
                              0.7,
                            )
                            : theme.textTheme.bodyMedium?.color,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
