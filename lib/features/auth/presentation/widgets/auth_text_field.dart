import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';


class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isObscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixPressed;
  final void Function(String)? onChanged;
  final bool readOnly;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.readOnly = false, this.onSuffixPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppTypography.labelLarge.copyWith(
        fontSize: 15.sp,
        color: theme.textTheme.bodyMedium?.color,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.labelLarge.copyWith(
          fontSize: 15.sp,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
        ),
        filled: true,
        fillColor: isDark ? theme.colorScheme.surface : Colors.grey[50],

        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),

        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),

        prefixIcon: Icon(
          prefixIcon,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
          size: 22.sp,
        ),

        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixPressed,
                icon: Icon(
                  suffixIcon,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  size: 22.sp,
                ),
              )
            : null,

        errorStyle: AppTypography.labelSmall.copyWith(
          fontSize: 12.sp,
          color: AppColors.error,
        ),
      ),
    );
  }
}
