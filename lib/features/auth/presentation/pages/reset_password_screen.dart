import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/utils/validators.dart';
import '../../../../core/routes/routes.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isConfirmObscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSuccess) {
          Navigator.pushReplacementNamed(context, Routes.passwordUpdated);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: theme.iconTheme.color, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Reset Password',
              style: AppTypography.h3.copyWith(
                  fontSize: 20.sp,
                  color: theme.textTheme.headlineMedium?.color)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                   Text(
                    'Your new password must be different from previously used passwords.',
                    style: AppTypography.bodyMedium.copyWith(
                        fontSize: 15.sp,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                  ),
                  SizedBox(height: 32.h),

                  Text('New Password',
                      style: AppTypography.labelLarge.copyWith(
                          fontSize: 14.sp,
                          color: theme.textTheme.bodyMedium?.color)),
                  SizedBox(height: 8.h),
                  AuthTextField(
                    controller: _passwordController,
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    isObscure: isObscure,
                    suffixIcon: isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixPressed: () =>
                        setState(() => isObscure = !isObscure),
                        readOnly: false,
                    validator: Validators.password,
                  ),
                  SizedBox(height: 24.h),

                  Text('Confirm New Password',
                      style: AppTypography.labelLarge.copyWith(
                          fontSize: 14.sp,
                          color: theme.textTheme.bodyMedium?.color)),
                  SizedBox(height: 8.h),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_reset_outlined,
                    isObscure: isConfirmObscure,
                    suffixIcon: isConfirmObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    onSuffixPressed: () =>
                        setState(() => isConfirmObscure = !isConfirmObscure),
                    validator: (value) =>
                        Validators.confirmPassword(value, _passwordController.text),
                        readOnly: false
                  ),
                  SizedBox(height: 40.h),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor:
                                colorScheme.primary.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r)),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                  child: const CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text('Update Password',
                                  style: AppTypography.button.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
            email: widget.email,
            otp: widget.otp,
            newPassword: _passwordController.text,
          );
    }
  }
}
