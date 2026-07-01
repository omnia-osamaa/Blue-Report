import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/routes/app_routes.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/utils/validators.dart';
import '../../../../core/routes/routes.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_label.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isConfirmObscure = true;
  bool agreeToTerms = false;
  bool _nationalIdFromScan = false;
  String? _setupToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['national_id'] != null) {
      _nationalIdController.text = args['national_id'].toString();
      _setupToken = args['setup_token']?.toString();
      _nationalIdFromScan = true;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistrationSuccess) {
          AppRouter.navigateAndRemoveUntil(context, Routes.accountCreated);
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
                  SizedBox(height: 10.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Image.asset(AppImages.logo),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'NEW GUARDIAN',
                          style: AppTypography.h6.copyWith(
                            fontSize: 12.sp,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  RichText(
                    text: TextSpan(
                      style: AppTypography.h2.copyWith(
                        fontSize: 28.sp,
                        color: theme.textTheme.headlineLarge?.color,
                      ),
                      children: [
                         TextSpan(
                          text: 'Join the\n',
                          style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Cleanup Network',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Text(
                    'Become a verified reporter and help us track river waste in real-time.',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 15.sp,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  const AuthLabel(text: 'Full Name'),
                  AuthTextField(
                    controller: _fullNameController,
                    hintText: 'full name',
                    prefixIcon: Icons.person_outline,
                    validator: (value) =>
                        Validators.minLength(value, 3, fieldName: 'Full Name'),
                    readOnly: false, onSuffixPressed: () {  },
                  ),
                  SizedBox(height: 16.h),

                  const AuthLabel(text: 'Email Address'),
                  AuthTextField(
                    controller: _emailController,
                    hintText: 'user@gmail.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    readOnly: false, onSuffixPressed: () {  },
                  ),
                  SizedBox(height: 16.h),

                  const AuthLabel(text: 'Phone Number'),
                  AuthTextField(
                    controller: _phoneController,
                    hintText: '(+20) 000-0000-000',
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                    readOnly: false, onSuffixPressed: () {  },
                  ),
                  SizedBox(height: 16.h),

                  const AuthLabel(text: 'National ID'),
                  if (_nationalIdFromScan)
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            size: 22.sp,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.5),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              _nationalIdController.text,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock_outline,
                            size: 18.sp,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.35),
                          ),
                        ],
                      ),
                    )
                  else
                    AuthTextField(
                      controller: _nationalIdController,
                      hintText: 'ID Number',
                      prefixIcon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          Validators.required(value, fieldName: 'National ID'),
                      readOnly: true, onSuffixPressed: () {  },
                    ),
                  SizedBox(height: 4.h),

                  if (_nationalIdFromScan)
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          size: 13.sp,
                          color: AppColors.success,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Verified via ID scan · Cannot be edited',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 11.sp,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Used only for identity verification.',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 12.sp,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),

                  SizedBox(height: 16.h),

                  const AuthLabel(text: 'Password'),
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
                    validator: Validators.password,
                    readOnly: false,
                  ),
                  SizedBox(height: 16.h),

                  const AuthLabel(text: 'Confirm Password'),
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
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    readOnly: false,
                  ),
                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Checkbox(
                        value: agreeToTerms,
                        onChanged: (value) =>
                            setState(() => agreeToTerms = value ?? false),
                        activeColor: colorScheme.primary,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.bodyMedium.copyWith(
                              fontSize: 13.sp,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: agreeToTerms ? _onRegister : null,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Account',
                            style: AppTypography.button.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.arrow_forward, size: 20.sp),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: RichText(
                        text: TextSpan(
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15.sp,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log In',
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

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        password: _passwordController.text,
        setupToken: _setupToken,
      );
    }
  }
}

