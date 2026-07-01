import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
