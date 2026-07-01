import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';

class SettingSectionLabel extends StatelessWidget {
  final String label;

  const SettingSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.45),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
