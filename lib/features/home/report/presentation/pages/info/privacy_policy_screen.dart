import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'bluesentinel9@gmail.com',
    );
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch email client');
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
          'Privacy Policy',
          style: AppTypography.h4.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Privacy Matters',
                        style: AppTypography.h4.copyWith(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Last updated: May 2026',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          ..._sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return _PolicyCard(
              index: index + 1,
              title: section['title']!,
              body: section['body']!,
              icon: section['icon'] as IconData,
              isDark: isDark,
              theme: theme,
              onEmailTap: (section['title'] == 'Contact Us') ? _launchEmail : null,
            );
          }),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _sections = [
    {
      'title': 'Data Collection',
      'icon': Icons.data_usage_rounded,
      'body':
          'We collect basic info like your name, email, and phone number to manage your account. Location data and photos are only captured when you submit a report.',
    },
    {
      'title': 'Data Usage',
      'icon': Icons.security_rounded,
      'body':
          'Your data helps us verify reports, track environmental impact, and manage rewards. We never sell your personal information to third parties.',
    },
    {
      'title': 'Data Security',
      'icon': Icons.lock_outline_rounded,
      'body':
          'We use industry-standard encryption to keep your information safe. You can request to delete your account and associated data at any time.',
    },
    {
      'title': 'Contact Us',
      'icon': Icons.alternate_email_rounded,
      'body':
          'Questions or concerns? Reach out to our dedicated privacy team anytime at bluesentinel9@gmail.com.',
    },
  ];
}

class _PolicyCard extends StatelessWidget {
  final int index;
  final String title;
  final String body;
  final IconData icon;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback? onEmailTap;

  const _PolicyCard({
    required this.index,
    required this.title,
    required this.body,
    required this.icon,
    required this.isDark,
    required this.theme,
    this.onEmailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark 
            ? AppColors.borderDark.withOpacity(0.5) 
            : AppColors.border.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '$index. $title',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          onEmailTap != null
            ? _buildBodyWithClickableEmail()
            : Text(
                body,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildBodyWithClickableEmail() {
    const email = 'bluesentinel9@gmail.com';
    final parts = body.split(email);
    
    return RichText(
      text: TextSpan(
        style: AppTypography.bodyMedium.copyWith(
          fontSize: 14.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          height: 1.5,
        ),
        children: [
          TextSpan(text: parts[0]),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: onEmailTap,
              child: Text(
                email,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
