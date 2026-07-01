import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/features/home/report/presentation/widgets/home%20widgets/status_filter.dart';
import '../../../domain/entities/report.dart';
import '../../bloc/report_cubit.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  ReportStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().loadUserReports();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context) ? IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: theme.iconTheme.color, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: Text(
          'My Reports',
          style: AppTypography.h4.copyWith(
            fontSize: 18.sp,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return Center(
              child: CircularProgressIndicator(
                  color: theme.colorScheme.primary),
            );
          }

          if (state is UserReportsLoaded) {
            final allReports = state.reports;

            final filteredReports = _selectedFilter == null
                ? allReports
                : allReports
                    .where((r) => r.status == _selectedFilter)
                    .toList();

            return RefreshIndicator(
              onRefresh: () => context.read<ReportCubit>().loadUserReports(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: StatusFilterChips(
                        selectedStatus: _selectedFilter,
                        onStatusSelected: (status) =>
                            setState(() => _selectedFilter = status),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  if (filteredReports.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64.sp,
                                color:
                                    theme.iconTheme.color?.withOpacity(0.3)),
                            SizedBox(height: 16.h),
                            Text(
                              _selectedFilter == null
                                  ? 'No reports yet'
                                  : 'No ${_selectedFilter!.name} reports',
                              style: AppTypography.bodyLarge.copyWith(
                                  fontSize: 16.sp,
                                  color:
                                      theme.textTheme.bodyMedium?.color),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final report = filteredReports[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: _ReportCard(
                                report: report,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  Routes.reportDetails,
                                  arguments: report,
                                ),
                              ),
                            );
                          },
                          childCount: filteredReports.length,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            );
          }

          if (state is UserReportsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64.sp, color: theme.colorScheme.error),
                  SizedBox(height: 16.h),
                  Text('Failed to load reports',
                      style: AppTypography.bodyLarge.copyWith(
                          fontSize: 16.sp,
                          color: theme.textTheme.bodyMedium?.color)),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ReportCubit>().loadUserReports(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;

  const _ReportCard({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    color: AppColors.primaryLight,
                    child: report.imagePath.startsWith('http')
                        ? Image.network(
                            report.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.image_not_supported,
                              color: AppColors.primary.withOpacity(0.4),
                              size: 28.sp,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            color: AppColors.primary.withOpacity(0.4),
                            size: 28.sp,
                          ),
                  ),
                ),

                SizedBox(width: 14.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          _StatusBadge(status: report.status),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 13.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              report.locationName ?? 'Unknown Location',
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 13.sp,
                                color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 13.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Text(
                            report.timeAgo,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Details',
                    style: AppTypography.labelMedium.copyWith(
                      fontSize: 13.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(Icons.arrow_forward_ios,
                      size: 12.sp, color: theme.colorScheme.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReportStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String text;
    late IconData icon;

    switch (status) {
      case ReportStatus.accepted:
        bg = AppColors.success.withOpacity(0.12);
        fg = AppColors.success;
        text = 'Accepted';
        icon = Icons.check_circle;
        break;
      case ReportStatus.rejected:
        bg = AppColors.error.withOpacity(0.12);
        fg = AppColors.error;
        text = 'Rejected';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: fg),
          SizedBox(width: 3.w),
          Text(text,
              style: AppTypography.labelSmall.copyWith(
                  fontSize: 11.sp, color: fg)),
        ],
      ),
    );
  }
}
