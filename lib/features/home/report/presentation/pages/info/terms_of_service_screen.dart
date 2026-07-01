import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
                    Icons.gavel_rounded,
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
                        'Terms of Use',
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
            return _TermsCard(
              index: index + 1,
              title: section['title']!,
              body: section['body']!,
              icon: section['icon'] as IconData,
              isDark: isDark,
              theme: theme,
              onEmailTap: (section['title'] == 'Responsibility') ? _launchEmail : null,
            );
          }),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _sections = [
    {
      'title': 'Use of App',
      'icon': Icons.app_registration_rounded,
      'body':
          'Blue Report is for reporting pollution. Users must provide honest information and accurate photos. Misuse or fake reports may lead to account suspension.',
    },
    {
      'title': 'Content',
      'icon': Icons.image_search_rounded,
      'body':
          'By submitting reports, you grant us permission to use the data for environmental research and reporting to authorities.',
    },
    {
      'title': 'Rewards',
      'icon': Icons.emoji_events_outlined,
      'body':
          'Points earned have no cash value and are subject to verification. We reserve the right to adjust points if reports are found invalid.',
    },
    {
      'title': 'Responsibility',
      'icon': Icons.info_outline_rounded,
      'body':
          'We provide the platform "as is". Action on reports depends on local authorities. For support, contact bluesentinel9@gmail.com.',
    },
  ];
}

class _TermsCard extends StatelessWidget {
  final int index;
  final String title;
  final String body;
  final IconData icon;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback? onEmailTap;

  const _TermsCard({
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
