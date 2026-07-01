import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/theme/colors.dart';

class SettingListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int? badge;
  final Color? iconColor;

  const SettingListItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 18.sp,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '$badge',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
            ],
            Icon(
              Icons.arrow_forward_ios,
              size: 13.sp,
              color: theme.iconTheme.color?.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
