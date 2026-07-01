import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/theme/colors.dart';
import '../../bloc/reward_cubit.dart';
import '../../../domain/entities/reward_entity.dart';

class RewardsStoreScreen extends StatefulWidget {
  const RewardsStoreScreen({super.key});

  @override
  State<RewardsStoreScreen> createState() => _RewardsStoreScreenState();
}

class _RewardsStoreScreenState extends State<RewardsStoreScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RewardCubit>().loadRewards();
  }

  int _getBalance(RewardState state) =>
      state.status == RewardStatus.loaded ? state.balance : 0;

  Future<void> _onRedeem(BuildContext context, RewardEntity product, int balance) async {
    if (balance < product.cost) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Confirm Redemption',
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.card_giftcard_rounded,
                  size: 30.sp, color: AppColors.primary),
            ),
            SizedBox(height: 12.h),
            Text(
              'Redeem "${product.title}" for ${product.cost} pts?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              'Remaining: ${balance - product.cost} pts',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    
    Navigator.pushNamed(
      context,
      '/order-summary',
      arguments: product,
    );
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
        leading: Navigator.canPop(context) ? IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ) : null,
        title: Text('Rewards Store',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<RewardCubit, RewardState>(
        builder: (context, state) {
          final balance = _getBalance(state);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                _BalanceBanner(balance: balance),

                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text('Featured Rewards',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 14.h),

                
                if (state.status == RewardStatus.loading)
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ))
                else if (state.status == RewardStatus.error)
                  Center(
                      child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Text(state.errorMessage ?? 'Failed to load rewards',
                            style: TextStyle(color: AppColors.error)),
                        SizedBox(height: 8.h),
                        TextButton(
                          onPressed: () =>
                              context.read<RewardCubit>().loadRewards(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ))
                else if (state.rewards.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Text('No rewards available.',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 0.63,
                      ),
                      itemCount: state.rewards.length,
                      itemBuilder: (context, index) {
                        final product = state.rewards[index];
                        final canAfford =
                            balance >= product.cost && !product.isRedeemed;
                        return _ProductCard(
                          product: product,
                          canAfford: canAfford,
                          isDark: isDark,
                          theme: theme,
                          onRedeem: () =>
                              _onRedeem(context, product, balance),
                        );
                      },
                    ),
                  ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }
}



class _BalanceBanner extends StatelessWidget {
  final int balance;
  const _BalanceBanner({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.eco, size: 26.sp, color: Colors.white),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR ECO-IMPACT BALANCE',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.wallet, color: Colors.white, size: 18.sp),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        balance.toString(),
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Text(
                        'pts',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
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



class _ProductCard extends StatelessWidget {
  final RewardEntity product;
  final bool canAfford;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onRedeem;

  const _ProductCard({
    required this.product,
    required this.canAfford,
    required this.isDark,
    required this.theme,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: canAfford && !product.isRedeemed
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Center(
                child: product.image != null && product.image!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Image.network(
                          product.image!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.card_giftcard_rounded,
                            size: 40.sp,
                            color: canAfford
                                ? AppColors.primary
                                : Colors.grey[400],
                          ),
                        ),
                      )
                    : Icon(
                        Icons.card_giftcard_rounded,
                        size: 40.sp,
                        color:
                            canAfford ? AppColors.primary : Colors.grey[400],
                      ),
              ),
            ),
          ),

          
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.workspace_premium,
                          size: 12.sp, color: AppColors.primary),
                      SizedBox(width: 3.w),
                      Flexible(
                        child: Text(
                          '${product.cost} pts',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30.h,
                    child: ElevatedButton(
                      onPressed:
                          canAfford && !product.isRedeemed ? onRedeem : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: isDark
                            ? AppColors.borderDark
                            : AppColors.border,
                        disabledForegroundColor: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        product.isRedeemed
                            ? 'Redeemed'
                            : (canAfford ? 'Redeem' : 'Not enough'),
                        style: TextStyle(
                            fontSize: 11.sp, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
