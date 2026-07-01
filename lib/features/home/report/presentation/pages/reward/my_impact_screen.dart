import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../../bloc/points_history_cubit.dart';
import '../../bloc/report_cubit.dart';

class MyImpactScreen extends StatefulWidget {
  const MyImpactScreen({super.key});

  @override
  State<MyImpactScreen> createState() => _MyImpactScreenState();
}

class _MyImpactScreenState extends State<MyImpactScreen> {
  @override
  void initState() {
    super.initState();
    
    context.read<ReportCubit>().loadHomeData();
    context.read<PointsHistoryCubit>().loadHistory();
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
        leading:
            Navigator.canPop(context)
                ? IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 18.sp),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        title: Text(
          'My Impact',
          style: AppTypography.h4.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, reportState) {
          final balance =
              reportState is HomeLoaded ? reportState.stats.totalPoints : 0;
          final badgeTitle =
              reportState is HomeLoaded
                  ? reportState.stats.badgeTitle
                  : 'Eco Warrior';
          final level =
              reportState is HomeLoaded ? reportState.stats.currentLevel : 1;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color:
                        isDark ? theme.colorScheme.primary : theme.primaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 4.w,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              balance.toString(),
                              style: AppTypography.h1.copyWith(
                                fontSize: 32.sp,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'PTS',
                              style: AppTypography.overline.copyWith(
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        badgeTitle,
                        style: AppTypography.h4.copyWith(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Level $level',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: AppTypography.h4.copyWith(fontSize: 16.sp),
                    ),
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(
                            context,
                            Routes.pointsHistory,
                          ),
                      child: Text(
                        'See All',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                BlocBuilder<PointsHistoryCubit, PointsHistoryState>(
                  builder: (context, state) {
                    if (state is PointsHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PointsHistoryError) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'Failed to load history',
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () =>
                                      context
                                          .read<PointsHistoryCubit>()
                                          .loadHistory(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is PointsHistoryLoaded) {
                      if (state.history.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Text(
                              'No activity yet',
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }

                      final preview = state.history.take(4).toList();

                      return Column(
                        children:
                            preview.map((item) {
                              final isEarned =
                                  item.type == 'earned' || item.points > 0;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: _buildTransactionCard(
                                  icon:
                                      isEarned
                                          ? Icons.check_circle
                                          : Icons.remove_circle_outline,
                                  title:
                                      item.description.isNotEmpty
                                          ? item.description
                                          : 'Points ${isEarned ? "Earned" : "Spent"}',
                                  subtitle: _timeAgo(
                                    DateTime.tryParse(item.createdAt) ??
                                        DateTime.now(),
                                  ),
                                  points:
                                      '${isEarned ? "+" : ""}${item.points}',
                                  isEarned: isEarned,
                                  theme: theme,
                                  isDark: isDark,
                                ),
                              );
                            }).toList(),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 80.h),

                SizedBox(height: 80.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String points,
    required bool isEarned,
    required ThemeData theme,
    required bool isDark,
  }) {
    final pointColor = isEarned ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border:
            isDark
                ? Border.all(color: theme.colorScheme.outline.withOpacity(0.1))
                : null,
        boxShadow:
            isDark
                ? null
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: pointColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: pointColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelLarge.copyWith(fontSize: 13.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.sp,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: pointColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              points,
              style: AppTypography.labelLarge.copyWith(
                fontSize: 13.sp,
                color: pointColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
