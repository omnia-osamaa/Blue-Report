import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../../bloc/points_history_cubit.dart';
import 'package:intl/intl.dart';

enum TransactionType { all, earned, spent }

class PointsHistoryScreen extends StatefulWidget {
  const PointsHistoryScreen({super.key});

  @override
  State<PointsHistoryScreen> createState() => _PointsHistoryScreenState();
}

class _PointsHistoryScreenState extends State<PointsHistoryScreen> {
  TransactionType _selectedFilter = TransactionType.all;

  @override
  void initState() {
    super.initState();
    context.read<PointsHistoryCubit>().loadHistory();
  }

  IconData _getIconForType(String type) {
    final t = type.toLowerCase();
    if (t == 'earned' || t == 'deposit') return Icons.add_chart_rounded;
    if (t == 'spent' || t == 'redeemed' || t == 'withdrawal') return Icons.account_balance_wallet_rounded;
    return Icons.eco_rounded;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy · hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.iconTheme.color,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wallet History',
          style: AppTypography.h4.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<PointsHistoryCubit, PointsHistoryState>(
        builder: (context, state) {
          if (state is PointsHistoryLoading && state is! PointsHistoryLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PointsHistoryError) {
            return Center(child: Text(state.message));
          } else if (state is PointsHistoryLoaded) {
            final allTransactions = state.history;

            final filteredTransactions = _selectedFilter == TransactionType.all
                ? allTransactions
                : allTransactions
                      .where((t) => t.type.toLowerCase() == _selectedFilter.name)
                      .toList();

            final totalLifetime = allTransactions
                .where((t) => (t.type.toLowerCase() == 'earned' || t.points > 0))
                .fold<int>(0, (sum, t) => sum + t.points.abs());

            final totalSpent = allTransactions
                .where((t) => (t.type.toLowerCase() == 'spent' || t.points < 0))
                .fold<int>(0, (sum, t) => sum + t.points.abs());

            final toRedeem = totalLifetime - totalSpent;

            return Column(
              children: [
                _buildBalanceCard(totalLifetime, toRedeem, isDark, theme),
                
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Activities', 
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 16.sp, 
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      _buildFilterDropdown(theme, isDark),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredTransactions.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 30.h),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredTransactions.length,
                          separatorBuilder: (_, __) => SizedBox(height: 16.h),
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            final isPositive = transaction.type.toLowerCase() == 'earned' || transaction.points > 0;

                            return _TransactionItem(
                              icon: _getIconForType(transaction.type),
                              title: transaction.description,
                              date: _formatDate(transaction.createdAt),
                              points: transaction.points.abs(),
                              isPositive: isPositive,
                              isDark: isDark,
                              theme: theme,
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildBalanceCard(int total, int current, bool isDark, ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL EARNED',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10.sp,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 4.h),
                  Text('$total pts',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CURRENT BALANCE',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4.h),
                      Text('$current',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text('Active',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
      ),
      child: DropdownButton<TransactionType>(
        value: _selectedFilter,
        underline: const SizedBox(),
        dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
        icon: Icon(Icons.filter_list_rounded, size: 16.sp, color: AppColors.primary),
        onChanged: (TransactionType? newValue) {
          if (newValue != null) setState(() => _selectedFilter = newValue);
        },
        items: TransactionType.values.map((TransactionType type) {
          return DropdownMenuItem<TransactionType>(
            value: type,
            child: Text(
              type.name.toUpperCase(),
              style: TextStyle(
                fontSize: 12.sp, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, size: 60.sp, color: AppColors.primary.withOpacity(0.2)),
          ),
          SizedBox(height: 16.h),
          Text('No Transactions Yet', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text('Your wallet history will appear here.', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final int points;
  final bool isPositive;
  final bool isDark;
  final ThemeData theme;

  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.points,
    required this.isPositive,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.withOpacity(0.1)
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: isPositive ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              icon,
              color: isPositive ? AppColors.success : AppColors.error,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? "+" : "-"}$points',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
              Text(
                'pts',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
