import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:flutter/services.dart';
import 'package:general_app/core/utils/app_notification.dart';
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import '../../bloc/reward_cubit.dart';
import '../../../domain/entities/reward_entity.dart';

class OrderSummaryScreen extends StatefulWidget {
  final RewardEntity product;
  const OrderSummaryScreen({super.key, required this.product});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _govController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.fullName;
      _phoneController.text = authState.user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _govController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder(BuildContext context, int balance) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await context.read<RewardCubit>().redeemReward(
        id: widget.product.id,
        fullName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        streetAddress: _streetController.text.trim(),
        city: _cityController.text.trim(),
        governorate: _govController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;

      AppNotification.show(
        context,
        title: 'Order Placed',
        message: 'Your reward is on the way!',
        icon: Icons.card_giftcard_rounded,
        color: AppColors.success,
      );

      await _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, size: 48.sp, color: AppColors.success),
            ),
            SizedBox(height: 24.h),
            Text(
              'Order Placed!',
              style: AppTypography.h3.copyWith(fontSize: 22.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              'Your reward is on the way!\nDelivery usually takes 5-7 business days.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                color: AppColors.getTextSecondary(Theme.of(context).brightness == Brightness.dark),
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: Text('Great!', style: AppTypography.button),
                ),
              ),
            ),
          ],
        ),
      ),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Summary',
          style: AppTypography.h4.copyWith(fontSize: 18.sp, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RewardCubit, RewardState>(
        builder: (context, state) {
          final balance = state.status == RewardStatus.loaded ? state.balance : 0;
          final remaining = balance - widget.product.cost;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductCard(isDark, theme),
                  SizedBox(height: 24.h),
                  _SectionCard(
                    icon: Icons.local_shipping_rounded,
                    title: 'Delivery Details',
                    child: Column(
                      children: [
                        _buildField(
                          controller: _nameController,
                          label: 'Recipient Name',
                          hint: 'Enter full name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter your full name';
                            if (v.trim().length < 3) return 'Name is too short';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildField(
                          controller: _phoneController,
                          label: 'Contact Number',
                          hint: '01xxxxxxxxx',
                          icon: Icons.phone_android_rounded,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please enter your phone number';
                            if (!RegExp(r'^01[0-9]{9}$').hasMatch(v)) return 'Enter a valid Egyptian number (01xxxxxxxxx)';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        _buildField(
                          controller: _streetController,
                          label: 'Shipping Address',
                          hint: 'Building, Street, Landmark',
                          icon: Icons.location_on_outlined,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter your shipping address';
                            if (v.trim().length < 5) return 'Address is too short';
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                controller: _cityController,
                                label: 'City',
                                hint: 'City',
                                icon: Icons.location_city_rounded,
                                validator: (v) => v == null || v.trim().isEmpty || v.trim().length < 2 ? 'Enter city' : null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildField(
                                controller: _govController,
                                label: 'Governorate',
                                hint: 'Governorate',
                                icon: Icons.map_rounded,
                                validator: (v) => v == null || v.trim().isEmpty || v.trim().length < 2 ? 'Enter gov.' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildField(
                          controller: _notesController,
                          label: 'Order Notes (Optional)',
                          hint: 'Floor, apartment, or landmarks...',
                          icon: Icons.comment_outlined,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _SectionCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Payment Breakdown',
                    child: Column(
                      children: [
                        _buildSummaryRow('Reward Value', '${widget.product.cost} pts'),
                        SizedBox(height: 12.h),
                        _buildSummaryRow('Available Balance', '$balance pts'),
                        SizedBox(height: 12.h),
                        _buildSummaryRow('Remaining Balance', '$remaining pts', isPrimary: true),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Divider(height: 1, color: theme.dividerColor.withOpacity(0.1)),
                        ),
                        _buildSummaryRow('Shipping Fee', '15.00 EGP', valueColor: AppColors.error),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Payable', style: AppTypography.h4.copyWith(fontSize: 16.sp)),
                              Text(
                                '${widget.product.cost} pts + 15 EGP',
                                style: AppTypography.h4.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.amber.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.amber.withOpacity(0.2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_rounded, size: 20.sp, color: Colors.amber[700]),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Note: The shipping fee (15 EGP) will be collected in cash upon delivery.',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 13.sp,
                              color: isDark ? AppColors.textSecondaryDark : Colors.amber[900],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  SizedBox(
                    width: double.infinity,
                    height: 58.h,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: _isSubmitting ? null : AppColors.primaryGradient,
                        color: _isSubmitting ? theme.dividerColor.withOpacity(0.1) : null,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: _isSubmitting ? null : [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : () => _confirmOrder(context, balance),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text('Confirm and Place Order', style: AppTypography.button.copyWith(fontSize: 16.sp)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(bool isDark, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: widget.product.image != null && widget.product.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      widget.product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.redeem_rounded, size: 32.sp, color: AppColors.primary),
                    ),
                  )
                : Icon(Icons.redeem_rounded, size: 32.sp, color: AppColors.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.title, style: AppTypography.h4.copyWith(fontSize: 16.sp)),
                SizedBox(height: 6.h),
                Text(
                  widget.product.description,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 13.sp,
                    color: AppColors.getTextSecondary(isDark),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${widget.product.cost} Points',
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    TextAlign textAlign = TextAlign.start,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelLarge.copyWith(
            fontSize: 13.sp,
            color: AppColors.getTextPrimary(isDark),
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          textAlign: textAlign,
          inputFormatters: inputFormatters,
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            counterText: "", 
            hintStyle: AppTypography.bodySmall.copyWith(
              fontSize: 14.sp,
              color: AppColors.getHintText(isDark),
            ),
            prefixIcon: Icon(icon, size: 20.sp, color: AppColors.primary),
            filled: true,
            fillColor: isDark ? AppColors.surfaceVariantDark : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor, bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14.sp,
            color: AppColors.getTextSecondary(Theme.of(context).brightness == Brightness.dark),
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 15.sp,
            fontWeight: isPrimary ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? (isPrimary ? AppColors.primary : AppColors.getTextPrimary(Theme.of(context).brightness == Brightness.dark)),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, size: 20.sp, color: AppColors.primary),
                ),
                SizedBox(width: 12.w),
                Text(title, style: AppTypography.h4.copyWith(fontSize: 16.sp)),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor.withOpacity(0.1)),
          Padding(padding: EdgeInsets.all(20.w), child: child),
        ],
      ),
    );
  }
}
