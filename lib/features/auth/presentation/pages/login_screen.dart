import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/routes/app_routes.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/utils/validators.dart';
import '../../../../core/routes/routes.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppRouter.navigateAndRemoveUntil(
            context,
            Routes.home,
            arguments: {'user': state.user},
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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
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

                  Center(
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Image.asset(
                        AppImages.logo,
                        width: 40.w,
                        height: 40.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTypography.h2.copyWith(
                          fontSize: 28.sp,
                          color: theme.textTheme.headlineLarge?.color,
                        ),
                        children: [
                          const TextSpan(text: 'Welcome '),
                          TextSpan(
                            text: 'Back',
                            style: AppTypography.h2.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Center(
                    child: Text(
                      'Sign in to continue reporting river\nwaste and tracking your impact.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14.sp,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),

                  Text(
                    'Email Address',
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 14.sp,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'user@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    readOnly: false, onSuffixPressed: () {  },
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Password',
                        style: AppTypography.labelLarge.copyWith(
                          fontSize: 14.sp,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.navigateTo(
                            context,
                            Routes.forgotPasswordMethod,
                            arguments: {
                              'email': _emailController.text.trim(),
                              'phone': '',
                            },
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.labelLarge.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    validator: (value) =>
                        Validators.password(value, minLength: 6),
                    readOnly: false,
                  ),
                  SizedBox(height: 32.h),

                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            disabledBackgroundColor: colorScheme.primary
                                .withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign In',
                                      style: AppTypography.button.copyWith(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(Icons.arrow_forward, size: 20.sp),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.h),

                  Center(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.nationalIdScan),
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15.sp,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: AppTypography.bodyMedium.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}

