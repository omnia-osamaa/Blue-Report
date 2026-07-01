import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../../../domain/entities/report.dart';

class StatusFilterChips extends StatelessWidget {
  final ReportStatus? selectedStatus;
  final Function(ReportStatus?) onStatusSelected;

  const StatusFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            context: context,
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusSelected(null),
            theme: theme,
            isDark: isDark,
          ),
          SizedBox(width: 12.w),
          _buildFilterChip(
            context: context,
            label: 'Accepted',
            isSelected: selectedStatus == ReportStatus.accepted,
            onTap: () => onStatusSelected(ReportStatus.accepted),
            theme: theme,
            isDark: isDark,
          ),

          SizedBox(width: 12.w),
          _buildFilterChip(
            context: context,
            label: 'Rejected',
            isSelected: selectedStatus == ReportStatus.rejected,
            onTap: () => onStatusSelected(ReportStatus.rejected),
            theme: theme,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : isDark
                  ? theme.colorScheme.surface
                  : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: isSelected
              ? null
              : Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
        ),
        child: Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            fontSize: 14.sp,
            color: isSelected
                ? Colors.white
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}
