import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../../../domain/entities/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;

  const ReportCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark
            ? Border.all(
                color: theme.colorScheme.outline.withOpacity(0.1),
                width: 1,
              )
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              bottomLeft: Radius.circular(16.r),
            ),
            child: Container(
              width: 80.w,
              height: 80.w,
              color: theme.colorScheme.primary.withOpacity(0.1),
              child: report.imagePath.startsWith('http')
                  ? Image.network(
                      report.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported,
                        color: theme.iconTheme.color?.withOpacity(0.3),
                      ),
                    )
                  : Icon(
                      Icons.image,
                      color: theme.iconTheme.color?.withOpacity(0.3),
                    ),
            ),
          ),

          
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${report.wasteType} Debris',
                          style: AppTypography.h4.copyWith(
                            fontSize: 15.sp,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      
                      _buildStatusBadge(theme),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          report.locationName ?? 'Unknown Location',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 13.sp,
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' • ${report.timeAgo}',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 13.sp,
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Cairo, EG',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.sp,
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (report.status) {
      case ReportStatus.accepted:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        text = 'Accepted';
        break;
      case ReportStatus.rejected:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        text = 'Rejected';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 11.sp,
          color: textColor,
        ),
      ),
    );
  }
}
