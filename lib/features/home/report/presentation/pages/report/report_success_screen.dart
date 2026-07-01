import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/colors.dart';
import 'package:general_app/core/theme/app_typography.dart';
import 'package:general_app/core/routes/routes.dart';
import 'package:general_app/core/routes/app_routes.dart';
import 'package:general_app/features/auth/presentation/widgets/check_circle_mark_widget.dart';
import 'package:general_app/features/auth/presentation/widgets/check_mark_widget.dart';
import '../../../domain/entities/report.dart';


class ReportSuccessScreen extends StatefulWidget {
  final Report report;

  const ReportSuccessScreen({super.key, required this.report});

  @override
  State<ReportSuccessScreen> createState() => _ReportSuccessScreenState();
}

class _ReportSuccessScreenState extends State<ReportSuccessScreen> {
  bool _showContent = false;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();

    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showContent = true);
    });

    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showButtons = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                SizedBox(height: 40.h),

                
                SuccessCircle(
                  size: 140.w,
                  primaryColor: widget.report.isAccepted ? AppColors.success : AppColors.error,
                  child: AnimatedCheckmark(
                    size: 40.w,
                    color: Colors.white,
                    duration: const Duration(milliseconds: 600),
                  ),
                ),

                SizedBox(height: 40.h),

                
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _showContent ? 1 : 0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    widget.report.isAccepted ? 'Report Accepted!' : 'Report Processed',
                    style: AppTypography.h1.copyWith(
                      fontSize: 28.sp,
                      color: theme.textTheme.headlineMedium?.color,
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _showContent ? 1 : 0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    widget.report.isAccepted
                        ? 'Thanks for keeping our rivers clean.\nYour report has been successfully accepted.'
                        : 'Your report has been processed.\nPlease check the details for more information.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 15.sp,
                      color: widget.report.isAccepted ? AppColors.success : AppColors.error,
                      height: 1.6,
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _showContent ? 1 : 0),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark ? theme.colorScheme.surface : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: isDark
                          ? Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.1),
                              width: 1,
                            )
                          : null,
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            color: (widget.report.isAccepted ? AppColors.success : AppColors.error).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.report.isAccepted ? Icons.monetization_on : Icons.error_outline,
                            color: widget.report.isAccepted ? AppColors.success : AppColors.error,
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),

                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.report.isAccepted ? 'Points Earned' : 'Report Rejected',
                                style: AppTypography.h4.copyWith(
                                  fontSize: 16.sp,
                                  color: theme.textTheme.titleMedium?.color,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                widget.report.isAccepted 
                                    ? 'Points added to your wallet'
                                    : 'Please review admin notes',
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 13.sp,
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.report.isAccepted ? '+${widget.report.pointsEarned}' : '0',
                              style: AppTypography.h1.copyWith(
                                fontSize: 26.sp,
                                color: widget.report.isAccepted ? AppColors.success : AppColors.error,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 3.h, left: 3.w),
                              child: Text(
                                'PTS',
                                style: AppTypography.overline.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: widget.report.isAccepted ? AppColors.success : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                
                AnimatedSlide(
                  offset: _showButtons ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: _showButtons ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              AppRouter.navigateAndRemoveUntil(
                                context,
                                Routes.home,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Back to Home',
                              style: AppTypography.button.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: OutlinedButton(
                            onPressed: () {
                              AppRouter.navigateTo(context, Routes.myReports);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(
                                color: theme.colorScheme.outline.withOpacity(
                                  0.3,
                                ),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                            ),
                            child: Text(
                              'View My Reports',
                              style: AppTypography.button.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
