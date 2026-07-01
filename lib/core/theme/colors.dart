import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF17B0CF);
  static const Color primaryDark = Color(0xFF17B0CF); 
  static const Color primaryLight = Color(0xFFE7F7FA);

  static const Color secondary = Color(0xFF4E8B97);
  static const Color secondaryDark = Color(0xFF17B0CF); 
  static const Color secondaryLight = Color(0xFF8B5BB5);

  static const Color accent = Color(0xFFF093FB);
  static const Color accentDark = Color(0xFFE080E8);
  static const Color accentLight = Color(0xFFFFB3FF);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  static const Color backgroundDark = Color(0xFF121212); 
  static const Color surfaceDark = Color(0xFF1E1E1E); 
  static const Color surfaceVariantDark = Color(0xFF2C2C2C); 

  static const Color textPrimary = Color(0xFF0E191B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color hintText = Color(0xFFA6C5CB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color textPrimaryDark = Color(0xFFE0E0E0); 
  static const Color textSecondaryDark = Color(0xFFB0B0B0); 
  static const Color hintTextDark = Color(0xFF808080); 
  static const Color textOnPrimaryDark = Color(0xFF000000); 

  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDAA5D);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF74B9FF);

  static const Color border = Color(0xFFDFE6E9);
  static const Color divider = Color(0xFF9CA3AF);

  static const Color borderDark = Color(0xFF404040);
  static const Color dividerDark = Color(0xFF303030);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static Color getBackground(bool isDark) =>
      isDark ? backgroundDark : background;

  static Color getSurface(bool isDark) => isDark ? surfaceDark : surface;

  static Color getSurfaceVariant(bool isDark) =>
      isDark ? surfaceVariantDark : surfaceVariant;

  static Color getTextPrimary(bool isDark) =>
      isDark ? textPrimaryDark : textPrimary;

  static Color getTextSecondary(bool isDark) =>
      isDark ? textSecondaryDark : textSecondary;

  static Color getHintText(bool isDark) => isDark ? hintTextDark : hintText;

  static Color getBorder(bool isDark) => isDark ? borderDark : border;

  static Color getDivider(bool isDark) => isDark ? dividerDark : divider;

  static Color getTextOnPrimary(bool isDark) =>
      isDark ? textOnPrimaryDark : textOnPrimary;
}
