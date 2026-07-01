import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../../../domain/entities/report.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  
                  report.imagePath.startsWith('http')
                      ? Image.network(
                          report.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primaryLight,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 64.sp,
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.primaryLight,
                          child: Icon(
                            Icons.image,
                            size: 64.sp,
                            color: AppColors.primary.withOpacity(0.4),
                          ),
                        ),

                  
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),

                  
                  Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    child: _buildStatusBadge(report.status),
                  ),

                  
                  Positioned(
                    bottom: 16.h,
                    right: 16.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            report.timeAgo,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    'Report Details',
                    style: AppTypography.h3.copyWith(
                      fontSize: 22.sp,
                      color: theme.textTheme.headlineMedium?.color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'ID: ${report.displayId}',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  
                  if (report.isAccepted) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.stars_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+${report.pointsEarned} Points Earned',
                                style: AppTypography.h4.copyWith(
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Verified on ${_formatDate(report.verifiedAt ?? report.createdAt)}',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  
                  if (report.isRejected && report.adminNote != null && report.adminNote!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.2),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.error,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Rejection Reason',
                                style: AppTypography.labelLarge.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            report.adminNote!,
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 14.sp,
                              color: isDark ? Colors.red[200] : Colors.red[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  
                  _buildSectionTitle('Report Details', theme),
                  SizedBox(height: 12.h),

                  _buildInfoCard(
                    isDark: isDark,
                    theme: theme,
                    children: [
                      _buildInfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Reported On',
                        value: _formatDate(report.createdAt),
                        theme: theme,
                      ),
                      if (report.verifiedAt != null) ...[
                        _buildDivider(isDark),
                        _buildInfoRow(
                          icon: Icons.verified_outlined,
                          label: 'Verified On',
                          value: _formatDate(report.verifiedAt!),
                          theme: theme,
                        ),
                      ],
                      _buildDivider(isDark),
                      _buildInfoRow(
                        icon: Icons.info_outline,
                        label: 'Status',
                        value: report.statusText,
                        valueColor: _getStatusColor(report.status),
                        theme: theme,
                      ),

                    ],
                  ),

                  SizedBox(height: 20.h),

                  
                  if (report.locationName != null ||
                      report.latitude != null) ...[
                    _buildSectionTitle('Location', theme),
                    SizedBox(height: 12.h),
                    _buildInfoCard(
                      isDark: isDark,
                      theme: theme,
                      children: [
                        if (report.locationName != null)
                          _buildInfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'Location',
                            value: report.locationName!,
                            theme: theme,
                          ),
                        if (report.latitude != null && report.longitude != null)
                          ...[],
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],

                  
                  if (report.additionalDetails != null) ...[
                    _buildSectionTitle('Additional Details', theme),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: isDark
                            ? Border.all(color: AppColors.borderDark)
                            : null,
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Text(
                        report.additionalDetails!,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 14.sp,
                          color: theme.textTheme.bodyMedium?.color,
                          height: 1.6,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  
                  if (report.isRejected) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, Routes.createReport),
                        icon: Icon(Icons.refresh, size: 20.sp),
                        label: Text(
                          'Submit New Report',
                          style: AppTypography.button.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: AppTypography.h4.copyWith(
        fontSize: 16.sp,
        color: theme.textTheme.headlineMedium?.color,
      ),
    );
  }

  Widget _buildInfoCard({
    required bool isDark,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: AppColors.primary.withOpacity(0.8),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 14.sp,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.labelLarge.copyWith(
                fontSize: 14.sp,
                color: valueColor ?? theme.textTheme.titleMedium?.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.borderDark : AppColors.border,
      indent: 48.w,
    );
  }

  Widget _buildStatusBadge(ReportStatus status) {
    Color bg;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case ReportStatus.accepted:
        bg = AppColors.success.withOpacity(0.15);
        textColor = AppColors.success;
        text = 'Accepted';
        icon = Icons.check_circle;
        break;
      case ReportStatus.rejected:
        bg = AppColors.error.withOpacity(0.15);
        textColor = AppColors.error;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: textColor),
          SizedBox(width: 6.w),
          Text(
            text,
            style: AppTypography.labelMedium.copyWith(
              fontSize: 13.sp,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.accepted:
        return AppColors.success;
      case ReportStatus.rejected:
        return AppColors.error;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
