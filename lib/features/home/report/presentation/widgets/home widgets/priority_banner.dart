import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/app_typography.dart';

class PriorityBanner extends StatelessWidget {
  final VoidCallback onReportNow;

  const PriorityBanner({
    super.key,
    required this.onReportNow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  image: AssetImage(AppIcons.priority),
                  width: 14.w,
                  height: 14.w,
                  color: Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  'PRIORITY',
                  style: AppTypography.overline.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report Waste',
                      style: AppTypography.h2.copyWith(
                        fontSize: 24.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Spot something that doesn't belong? Snap a photo to alert the cleanup crew",
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 12.w),
              
              
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Image(
                    image: AssetImage(AppIcons.camera),
                    width: 28.w,
                    height: 28.w,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          
          GestureDetector(
            onTap: onReportNow,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Report Now',
                    style: AppTypography.button.copyWith(
                      fontSize: 16.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward,
                    color: theme.colorScheme.primary,
                    size: 18.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
