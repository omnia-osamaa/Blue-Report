import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/service/local_notification_service.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/features/home/report/presentation/pages/setting/setting_drawer_screen.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/features/auth/domain/entities/user.dart';
import 'package:general_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:general_app/core/config/app_config.dart';
import 'package:general_app/core/utils/extensions.dart';
import '../../bloc/notification_cubit.dart';
import '../../bloc/report_cubit.dart';
import '../../widgets/home widgets/priority_banner.dart';
import '../../widgets/home widgets/stats_card.dart';
import '../../widgets/home widgets/report_card.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().loadHomeData();

    _initNotifications();
  }

  Future<void> _initNotifications() async {
    final service = LocalNotificationService();
    await service.init();

    final hasPermission = await service.hasPermission();
    if (!hasPermission) {
      await service.requestPermission();
    }

    if (mounted) {
      context.read<NotificationCubit>().loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final authState = context.watch<AuthCubit>().state;
    final user =
        authState is AuthAuthenticated
            ? authState.user
            : (authState is AuthUpdatingProfile ? authState.user : widget.user);

    final userImageUrl = user.profileImage;
    final fullImageUrl =
        userImageUrl != null && userImageUrl.isNotEmpty
            ? (userImageUrl.startsWith('http')
                ? userImageUrl
                : '${AppConfig.baseUrl}${userImageUrl.startsWith('/') ?
                 '' : '/'}${userImageUrl.contains('storage') 
                 ? '' : 'storage/'}$userImageUrl')
            : null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      endDrawer: const SettingsDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<ReportCubit>().refreshHome(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.profile);
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            image:
                                fullImageUrl != null
                                    ? DecorationImage(
                                      image: NetworkImage(fullImageUrl),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              fullImageUrl == null
                                  ? Icon(
                                    Icons.person,
                                    color: theme.colorScheme.primary,
                                    size: 24.sp,
                                  )
                                  : null,
                        ),
                      ),
                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ECO WARRIOR',
                              style: AppTypography.overline.copyWith(
                                fontSize: 10.sp,
                                color: theme.colorScheme.primary,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Hi, ${user.fullName.split(' ').first}',
                              style: AppTypography.h4.copyWith(
                                fontSize: 18.sp,
                                color: theme.textTheme.headlineMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      ),

                      BlocBuilder<NotificationCubit, NotificationState>(
                        builder: (context, state) {
                          final unread =
                              state is NotificationLoaded
                                  ? state.notifications
                                      .where((n) => !n.isRead)
                                      .length
                                  : 0;
                          return GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  Routes.notifications,
                                ).then((_) {
                                  if (mounted) {
                                    context
                                        .read<NotificationCubit>()
                                        .loadNotifications();
                                  }
                                }),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    color: theme.colorScheme.primary,
                                    size: 22.sp,
                                  ),
                                ),
                                if (unread > 0)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 18.w,
                                      height: 18.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          unread > 9 ? '9+' : '$unread',
                                          style: AppTypography.labelSmall
                                              .copyWith(
                                                fontSize: 9.sp,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(width: 8.w),

                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: theme.iconTheme.color,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.h1.copyWith(
                        fontSize: 28.sp,
                        color: theme.textTheme.headlineLarge?.color,
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: "Let's restore\n"),
                        TextSpan(
                          text: "nature's balance.",
                          style: AppTypography.h1.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h).toSliver,

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: PriorityBanner(
                    onReportNow: () {
                      Navigator.pushNamed(context, Routes.createReport);
                    },
                  ),
                ),
              ),

              SizedBox(height: 24.h).toSliver,

              BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap:
                                      () => Navigator.pushNamed(
                                        context,
                                        Routes.myImpact,
                                      ),
                                  child: StatsCard(
                                    image: AppIcons.leaf,
                                    title: 'Total Points',
                                    value: state.stats.totalPoints.toString(),
                                    subtitle:
                                        '+${state.stats.pointsToNextLevel} to next level',
                                    progress: state.stats.progressToNextLevel,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: StatsCard(
                                  image: AppIcons.prize,
                                  title: state.stats.badgeTitle,
                                  value: 'Level ${state.stats.currentLevel}',
                                  subtitle: '',
                                  showProgress: false,
                                  showView: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              SizedBox(height: 32.h).toSliver,

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: AppTypography.h3.copyWith(
                          fontSize: 20.sp,
                          color: theme.textTheme.headlineMedium?.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.myReports);
                        },
                        child: Text(
                          'View All',
                          style: AppTypography.labelLarge.copyWith(
                            fontSize: 14.sp,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h).toSliver,

              BlocBuilder<ReportCubit, ReportState>(
                builder: (context, state) {
                  if (state is ReportLoading) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    if (state.recentActivity.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64.sp,
                                color: theme.iconTheme.color?.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No reports yet',
                                style: AppTypography.bodyLarge.copyWith(
                                  fontSize: 16.sp,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final report = state.recentActivity[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: ReportCard(report: report),
                          );
                        }, childCount: state.recentActivity.length),
                      ),
                    );
                  }

                  if (state is HomeError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Failed to load data',
                              style: AppTypography.bodyLarge.copyWith(
                                fontSize: 16.sp,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextButton(
                              onPressed:
                                  () =>
                                      context
                                          .read<ReportCubit>()
                                          .loadHomeData(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      ),
    );
  }
}
