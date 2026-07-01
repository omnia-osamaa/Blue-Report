import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/features/auth/domain/entities/user.dart';
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:general_app/features/home/report/presentation/bloc/report_cubit.dart';
import 'package:general_app/core/config/app_config.dart';
import '../../widgets/profile_widgets/profile_section_title.dart';
import '../../widgets/profile_widgets/profile_settings_card.dart';
import '../../widgets/profile_widgets/profile_setting_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final reportState = context.read<ReportCubit>().state;
    if (reportState is! HomeLoaded) {
      context.read<ReportCubit>().loadHomeData();
    }
  }

  User? _getUserFromState(AuthState state) {
    if (state is AuthAuthenticated) return state.user;
    if (state is AuthUpdatingProfile) return state.user;
    return null;
  }

  String? _buildImageUrl(String? userImageUrl) {
    if (userImageUrl == null || userImageUrl.isEmpty) return null;
    if (userImageUrl.startsWith('http')) return userImageUrl;
    return '${AppConfig.baseUrl}${userImageUrl.startsWith('/') ? '' : '/'}${userImageUrl.contains('storage') ? '' : 'storage/'}$userImageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = context.watch<AuthCubit>().state;
    final user = _getUserFromState(authState);
    final userName = user?.fullName ?? '';
    final fullImageUrl = _buildImageUrl(user?.profileImage);

    final reportState = context.watch<ReportCubit>().state;
    final points = reportState is HomeLoaded ? reportState.stats.totalPoints : 0;
    final badge = reportState is HomeLoaded ? reportState.stats.badgeTitle : 'Eco Warrior';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: AppTypography.h4.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: fullImageUrl == null
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                              theme.colorScheme.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    image: fullImageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(fullImageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: fullImageUrl == null
                      ? Icon(Icons.person, size: 60.sp, color: Colors.white)
                      : null,
                ),
                
                if (authState is AuthUpdatingProfile)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 16.h),

            Text(
              userName,
              style: AppTypography.h2.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
              ),
            ),
            SizedBox(height: 4.h),

            Text(
              badge,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14.sp,
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),

            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop, size: 18.sp, color: theme.colorScheme.primary),
                  SizedBox(width: 6.w),
                  Text(
                    '$points Points',
                    style: AppTypography.labelLarge.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            const ProfileSectionTitle(title: 'Account Settings'),
            SizedBox(height: 12.h),
            ProfileSettingsCard(
              children: [
                ProfileSettingItem(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () => Navigator.pushNamed(context, Routes.editProfile),
                ),
                _buildDivider(theme),
                ProfileSettingItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () => Navigator.pushNamed(context, Routes.notifications),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            const ProfileSectionTitle(title: 'Legal Info'),
            SizedBox(height: 12.h),
            ProfileSettingsCard(
              children: [
                ProfileSettingItem(
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () => Navigator.pushNamed(context, Routes.aboutUs),
                ),
                _buildDivider(theme),
                ProfileSettingItem(
                  icon: Icons.description,
                  title: 'Privacy Policy',
                  onTap: () => Navigator.pushNamed(context, Routes.privacyPolicy),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: Icon(Icons.logout, size: 20.sp, color: AppColors.error),
                label: Text(
                  'Logout',
                  style: AppTypography.button.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.1)),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await this.context.read<AuthCubit>().logout();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                this.context,
                Routes.login,
                (route) => false,
              );
            },
            child: Text('Logout', style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
