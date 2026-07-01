import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/features/home/report/domain/entities/earn_info_entity.dart';
import 'package:general_app/core/utils/app_notification.dart';
import 'package:general_app/features/home/report/presentation/bloc/reward_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/report_cubit.dart';
import 'package:general_app/core/theme/app_images.dart';

class EarnMoneyScreen extends StatefulWidget {
  const EarnMoneyScreen({super.key});

  @override
  State<EarnMoneyScreen> createState() => _EarnMoneyScreenState();
}

class _EarnMoneyScreenState extends State<EarnMoneyScreen> {
  String? _selectedMethod;

  final List<Map<String, dynamic>> _payoutMethods = [
    {
      'id': 'vodafone_cash',
      'name': 'Vodafone Cash',
      'image': AppImages.vodafone,
      'description': 'Fast & secure · Instant',
      'color': const Color(0xFFE60000),
    },
    {
      'id': 'instapay',
      'name': 'InstaPay',
      'image': AppImages.instapay,
      'description': 'Min 500 pts · Instant',
      'color': const Color(0xFF6C63FF),
    },
    {
      'id': 'etisalat_cash',
      'name': 'Etisalat Cash',
      'image': AppImages.etisalat,
      'description': 'Instant wallet deposit',
      'color': const Color(0xFF71B31E),
    },
    {
      'id': 'orange_cash',
      'name': 'Orange Cash',
      'image': AppImages.orange,
      'description': 'Secure digital wallet',
      'color': const Color(0xFFFF7900),
    },
    {
      'id': 'we_pay',
      'name': 'WE Pay',
      'image': AppImages.wepay,
      'description': 'Secure wallet payments',
      'color': const Color(0xFF4B1E78),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final reportCubit = context.read<ReportCubit>();
      if (reportCubit.state is! HomeLoaded) {
        reportCubit.loadHomeData();
      }

      final rewardCubit = context.read<RewardCubit>();
      if (rewardCubit.state.earnInfo == null) {
        rewardCubit.loadEarnInfo();
      }
    });
  }
  void _showWithdrawSheet(BuildContext context, int balance) {
    if (_selectedMethod == null) return;
    final method = _payoutMethods.firstWhere((m) => m['id'] == _selectedMethod);
    final earnInfo = context.read<RewardCubit>().state.earnInfo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<RewardCubit>()),
              BlocProvider.value(value: context.read<ReportCubit>()),
            ],
            child: _WithdrawSheet(
              method: method,
              maxPoints: balance,
              selectedMethodId: _selectedMethod!,
              earnInfo: earnInfo,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: theme.iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Earn Money',
          style: AppTypography.h4.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceHeader(isDark, theme),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Withdrawal Methods',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Select how you want to receive your cash',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<RewardCubit, RewardState>(
                    builder: (context, state) {
                      final label =
                          state.earnInfo?.exchangeLabel ??
                          '10 pts = 1 EGP  ·  Minimum: 500 pts';
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 18.sp,
                              color: primaryColor,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  ...(_payoutMethods.map(
                    (method) => _buildMethodCard(method, isDark, theme),
                  )),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(theme),
    );
  }

  Widget _buildBalanceHeader(bool isDark, ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          final balance = state is HomeLoaded ? state.stats.totalPoints : 0;
          final egp = (balance / 10).toStringAsFixed(2);
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AVAILABLE POINTS',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 10.sp,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            balance.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34.sp,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'pts',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'CASH VALUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '£$egp',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMethodCard(
    Map<String, dynamic> method,
    bool isDark,
    ThemeData theme,
  ) {
    final isSelected = _selectedMethod == method['id'];
    final Color methodColor = method['color'];
    final primaryColor = theme.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = method['id']),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color:
                  isSelected
                      ? primaryColor
                      : (isDark
                          ? theme.dividerColor.withOpacity(0.1)
                          : Colors.grey[200]!),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: methodColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Image.asset(
                  method['image'],
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) =>
                          Icon(Icons.wallet, color: methodColor, size: 24.sp),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      method['description'],
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: method['id'],
                groupValue: _selectedMethod,
                activeColor: primaryColor,
                onChanged: (v) => setState(() => _selectedMethod = v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
        ),
      ),
      child: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          final balance = state is HomeLoaded ? state.stats.totalPoints : 0;
          final isEnabled = _selectedMethod != null && balance >= 500;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (balance < 500)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(
                    'Need ${500 - balance} more points to withdraw',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed:
                    !isEnabled
                        ? null
                        : () => _showWithdrawSheet(context, balance),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WithdrawSheet extends StatefulWidget {
  final Map<String, dynamic> method;
  final int maxPoints;
  final String selectedMethodId;
  final EarnInfoEntity? earnInfo;

  const _WithdrawSheet({
    required this.method,
    required this.maxPoints,
    required this.selectedMethodId,
    this.earnInfo,
  });

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  int _pointsToWithdraw = 500;
  bool _phoneValid = false;

  int get _minPts => widget.earnInfo?.minPoints ?? 500;
  double get _exchangeRate => widget.earnInfo?.exchangeRate ?? 0.1;

  @override
  void initState() {
    super.initState();
    _pointsToWithdraw = _minPts;
    _amountController.text = _pointsToWithdraw.toString();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _phoneValid &&
      _pointsToWithdraw >= _minPts &&
      _pointsToWithdraw <= widget.maxPoints;
  double get _egpValue => _pointsToWithdraw * _exchangeRate;

  void _onAmountChanged(String v) {
    if (v.isEmpty) {
      setState(() => _pointsToWithdraw = 0);
      return;
    }
    final int? val = int.tryParse(v);
    if (val != null) {
      setState(() {
        _pointsToWithdraw = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Image.asset(
                  widget.method['image'],
                  width: 40.w,
                  height: 40.w,
                  errorBuilder: (_, __, ___) => Icon(Icons.wallet, size: 40.w),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    'Withdraw via ${widget.method['name']}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark ? theme.colorScheme.surface : Colors.grey[50],
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enter Points to Withdraw',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 24.sp,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white,
                      hintText: 'Min: $_minPts',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      suffixText: 'pts',
                    ),
                    onChanged: _onAmountChanged,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Cash Value',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        '£${_egpValue.toStringAsFixed(2)} EGP',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (_pointsToWithdraw > widget.maxPoints)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Insufficient points!',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (_pointsToWithdraw < _minPts && _pointsToWithdraw > 0)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Minimum withdrawal is $_minPts points',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Wallet Number',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              onChanged:
                  (v) => setState(
                    () => _phoneValid = RegExp(r'^01[0-9]{9}$').hasMatch(v),
                  ),
              decoration: InputDecoration(
                hintText: '01xxxxxxxxx',
                counterText: '',
                prefixIcon: const Icon(Icons.phone_iphone),
                filled: true,
                fillColor: isDark ? theme.colorScheme.surface : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            BlocConsumer<RewardCubit, RewardState>(
              listenWhen: (prev, curr) => prev.status != curr.status,
              listener: (context, state) {
                if (state.status == RewardStatus.success) {
                  try {
                    context.read<ReportCubit>().loadHomeData();

                    AppNotification.show(
                      context,
                      title: 'Withdrawal Success',
                      message: 'Your request has been placed successfully!',
                      icon: Icons.account_balance_wallet_rounded,
                      color: AppColors.success,
                    );
                  } catch (e) {
                    debugPrint('Success handling error: $e');
                  } finally {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  }
                } else if (state.status == RewardStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'An error occurred'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state.status == RewardStatus.loading;
                return ElevatedButton(
                  onPressed:
                      (!_canSubmit || isLoading)
                          ? null
                          : () {
                            FocusScope.of(
                              context,
                            ).unfocus(); // Manually hide keyboard to prevent animation conflict
                            context.read<RewardCubit>().convertToCash(
                              points: _pointsToWithdraw,
                              cashMethod: widget.selectedMethodId,
                              phoneNumber: _phoneController.text,
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: Size(double.infinity, 60.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: (_canSubmit && !isLoading) ? 4 : 0,
                  ),
                  child:
                      isLoading
                          ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Confirm Withdrawal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
