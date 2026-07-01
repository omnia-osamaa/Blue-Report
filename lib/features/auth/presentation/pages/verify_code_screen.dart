import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/routes/routes.dart';
import '../bloc/auth_cubit.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String method; 

  const VerifyCodeScreen({
    super.key,
    required this.email,
    required this.method,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _timerSeconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds == 0) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_otp.length == 4) {
      Future.delayed(const Duration(milliseconds: 100), _verify);
    }
  }

  void _onKeyBack(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verify() {
    if (_otp.length < 4) {
      _showSnackBar('Please enter the 4-digit code');
      return;
    }
    context.read<AuthCubit>().verifyOtp(otp: _otp, email: widget.email);
  }

  void _resend() {
    if (!_canResend) return;
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
    context.read<AuthCubit>().resendOtp(widget.email);
    _startTimer();
  }

  void _clearFields() {
    for (final c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
  }

  void _showSnackBar(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ));
  }

  String _maskContact() {
    if (widget.method == 'sms') {
      if (widget.email.length < 4) return widget.email;
      return '+** ****${widget.email.substring(widget.email.length - 2)}';
    }
    final parts = widget.email.split('@');
    if (parts.length != 2) return widget.email;
    final name = parts[0];
    final domain = parts[1];
    final masked = name.length > 2
        ? '${name.substring(0, 2)}${'*' * (name.length - 2)}'
        : name;
    return '$masked@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerified) {
          Navigator.pushReplacementNamed(
            context,
            Routes.resetPassword,
            arguments: {'email': widget.email, 'otp': _otp},
          );
        } else if (state is AuthOtpResent) {
          _showSnackBar('Code resent successfully!', isError: false);
        } else if (state is AuthError) {
          _clearFields();
          _showSnackBar(state.message);
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mark_email_read_outlined,
                      size: 40.sp, color: AppColors.primary),
                ),
                SizedBox(height: 24.h),

                Text(
                  'Verification Code',
                  style: AppTypography.h2.copyWith(
                    fontSize: 24.sp,
                    color: theme.textTheme.headlineMedium?.color,
                  ),
                ),
                SizedBox(height: 10.h),

                Text(
                  'We sent a code to\n${_maskContact()}',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 36.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    return Container(
                      width: 64.w,
                      height: 64.w,
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      child: KeyboardListener(
                        focusNode: FocusNode(),
                        onKeyEvent: (event) {
                          if (event is KeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace) {
                            _onKeyBack(i);
                          }
                        },
                        child: TextFormField(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: AppTypography.h2.copyWith(
                            fontSize: 24.sp,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: isDark
                                ? AppColors.surfaceDark
                                : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          onChanged: (v) => _onDigitChanged(i, v),
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 28.h),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _canResend
                      ? GestureDetector(
                          key: const ValueKey('resend'),
                          onTap: _resend,
                          child: RichText(
                            text: TextSpan(
                              text: "Didn't receive the code? ",
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 14.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Resend',
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          key: const ValueKey('timer'),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined,
                                  size: 16.sp, color: AppColors.primary),
                              SizedBox(width: 6.w),
                              Text(
                                'Resend in 00:${_timerSeconds.toString().padLeft(2, '0')}',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

                SizedBox(height: 36.h),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.5),
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
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      size: 20.sp),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Verify Code',
                                    style: AppTypography.button.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
