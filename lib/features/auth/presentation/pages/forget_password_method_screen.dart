import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/forgot_password_method_card.dart';

class ForgotPasswordMethodScreen extends StatefulWidget {
  final String email;
  final String phone;

  const ForgotPasswordMethodScreen({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  State<ForgotPasswordMethodScreen> createState() =>
      _ForgotPasswordMethodScreenState();
}

class _ForgotPasswordMethodScreenState
    extends State<ForgotPasswordMethodScreen> {
  String _selectedMethod = 'email';

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name[0]}${name[1]}${'*' * (name.length - 2)}@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordSent) {
          Navigator.pushNamed(
            context,
            Routes.verifyCode,
            arguments: {'email': widget.email, 'method': _selectedMethod},
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Forgot Password',
            style: AppTypography.h4.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              SizedBox(height: 40.h),

              Center(
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 56.sp,
                    color: colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              Text(
                'Select which contact details should we use to reset your password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),

              SizedBox(height: 36.h),

              ForgotPasswordMethodCard(
                icon: Icons.email_outlined,
                title: 'Via Email',
                subtitle: _maskEmail(widget.email),
                value: 'email',
                isSelected: _selectedMethod == 'email',
                onTap: () => setState(() => _selectedMethod = 'email'),
              ),

              SizedBox(height: 60.h),

              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthCubit>().forgotPassword(
                                widget.email,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        disabledBackgroundColor: colorScheme.primary
                            .withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Continue',
                              style: AppTypography.button.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

