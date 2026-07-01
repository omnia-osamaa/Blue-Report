import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';

class ReportStatsHeader extends StatelessWidget {
  final int impactScore;
  final int cleanedSites;

  const ReportStatsHeader({
    super.key,
    required this.impactScore,
    required this.cleanedSites,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : theme.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IMPACT SCORE',
                  style: AppTypography.overline.copyWith(
                    fontSize: 10.sp,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      impactScore.toString(),
                      style: AppTypography.h1.copyWith(
                        fontSize: 28.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        'pts',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          
          Container(
            width: 1,
            height: 40.h,
            color: Colors.white.withOpacity(0.2),
          ),

          SizedBox(width: 20.w),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CLEANED',
                  style: AppTypography.overline.copyWith(
                    fontSize: 10.sp,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cleanedSites.toString(),
                      style: AppTypography.h1.copyWith(
                        fontSize: 28.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        'sites',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
