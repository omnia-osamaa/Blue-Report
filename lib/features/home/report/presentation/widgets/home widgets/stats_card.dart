import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';

class StatsCard extends StatelessWidget {
  final String image;
  final String title;
  final String value;
  final String subtitle;
  final bool showProgress;
  final double? progress;
  final Color? iconBackgroundColor;
  final Color? progressColor;

  final bool showView;

  const StatsCard({
    super.key,
    required this.image,
    required this.title,
    required this.value,
    required this.subtitle,
    this.showProgress = true,
    this.showView = true,
    this.progress,
    this.iconBackgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color:
                      iconBackgroundColor ??
                      theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: image.length <= 2
                      ? Text(image, style: AppTypography.bodyMedium.copyWith(fontSize: 14.sp))
                      : Image.asset(image, width: 16.w, height: 16.w),
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.overline.copyWith(
                    fontSize: 10.sp,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          
          Text(
            value,
            style: AppTypography.h3.copyWith(
              fontSize: 20.sp,
              color: theme.textTheme.headlineMedium?.color,
            ),
          ),

          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showProgress) ...[
                Text(
                  subtitle,
                  style: AppTypography.labelMedium.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 7.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3.r),
                  child: LinearProgressIndicator(
                    value: progress ?? 0.5,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressColor ?? AppColors.success,
                    ),
                    minHeight: 6.h,
                  ),
                ),
              ] else ...[
                SizedBox(height: 10.sp + 6.h + 4.h), 
              ],
            ],
          ),
          if (showView) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View',
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: 10.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 8.sp,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

