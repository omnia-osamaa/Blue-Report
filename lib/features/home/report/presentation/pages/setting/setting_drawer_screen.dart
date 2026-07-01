import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import '../../widgets/setting_widgets/setting_section_label.dart';
import '../../widgets/setting_widgets/setting_group_card.dart';
import '../../widgets/setting_widgets/setting_list_item.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Logout',
          style: AppTypography.h4.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTypography.bodyMedium.copyWith(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthCubit>().logout();
              if (!mounted) return;
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: theme.iconTheme.color?.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Settings',
                      style: AppTypography.h4.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              const SettingSectionLabel(label: 'ACCOUNT'),
              SizedBox(height: 8.h),
              SettingGroupCard(
                children: [
                  SettingListItem(
                    icon: Icons.person_outline,
                    label: 'Profile Information',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.profile);
                    },
                  ),
                  _divider(theme),
                ],
              ),
              SizedBox(height: 20.h),
              
              const SettingSectionLabel(label: 'ACTIVITY'),
              SizedBox(height: 8.h),
              SettingGroupCard(
                children: [
                  SettingListItem(
                    icon: Icons.bar_chart_outlined,
                    label: 'My Impact',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.myImpact);
                    },
                  ),
                  _divider(theme),
                  SettingListItem(
                    icon: Icons.history_outlined,
                    label: 'My Reports',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.myReports);
                    },
                  ),
                  _divider(theme),
                  SettingListItem(
                    icon: Icons.card_giftcard_outlined,
                    label: 'Rewards Store',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.rewardsStore);
                    },
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              const SettingSectionLabel(label: 'ABOUT'),
              SizedBox(height: 8.h),
              SettingGroupCard(
                children: [
                  SettingListItem(
                    icon: Icons.info_outline,
                    label: 'About Us',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.aboutUs);
                    },
                  ),
                  _divider(theme),
                  SettingListItem(
                    icon: Icons.shield_outlined,
                    label: 'Privacy Policy',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.privacyPolicy);
                    },
                  ),
                  _divider(theme),
                  SettingListItem(
                    icon: Icons.description_outlined,
                    label: 'Terms of Service',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.termsOfService);
                    },
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _logout(context),
                    icon: Icon(
                      Icons.logout,
                      size: 18.sp,
                      color: AppColors.error,
                    ),
                    label: Text(
                      'Logout',
                      style: AppTypography.button.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: Divider(height: 1, color: theme.dividerColor.withOpacity(0.07)),
  );
}
