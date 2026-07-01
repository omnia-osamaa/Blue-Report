import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/theme/app_typography.dart';
import '../../domain/entities/onboarding_item.dart';
import 'step_card.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingItem item;
  final int currentPage;
  final int totalPages;
  final PageController pageController;
  final VoidCallback onNextPressed;
  final VoidCallback onSkipPressed;

  const OnboardingContent({
    super.key,
    required this.item,
    required this.currentPage,
    required this.totalPages,
    required this.pageController,
    required this.onNextPressed,
    required this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isStepsPage = item.isStepPage;

    if (isStepsPage) {
      return _buildStepsPage(context, theme);
    } else {
      return _buildImagePage(context, theme);
    }
  }

  Widget _buildImagePage(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? colorScheme.background : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Top Section: Image with rounded corners
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        image: DecorationImage(
                          image: AssetImage(item.imagePath),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                    ),
                    if (item.showSkip)
                      Positioned(
                        top: 16.h,
                        right: 16.w,
                        child: _buildSkipButton(context, theme, isOnImage: true),
                      ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRichTitle(context, theme),
                    SizedBox(height: 16.h),
                    Text(
                      item.description,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 16.sp,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    _buildMainButton(theme),
                    SizedBox(height: 40.h), 
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsPage(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? colorScheme.background : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'HOW IT WORKS',
                      style: AppTypography.overline.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  _buildSkipButton(context, theme, isOnImage: false),
                ],
              ),
              SizedBox(height: 24.h),

              _buildRichTitle(context, theme, isSteps: true),
              SizedBox(height: 12.h),

              Text(
                item.description,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 15.sp,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    StepCard(
                      image: Image.asset(AppIcons.camera),
                      stepNumber: '1',
                      title: 'Capture',
                      description: 'Take a clear photo of the waste found',
                    ),
                    SizedBox(height: 12.h),
                    StepCard(
                      image: Image.asset(AppIcons.location),
                      stepNumber: '2',
                      title: 'Report',
                      description: 'Tag location and submit securely',
                    ),
                    SizedBox(height: 12.h),
                    StepCard(
                      image: Image.asset(AppIcons.potted),
                      stepNumber: '3',
                      title: 'Impact',
                      description: 'Earn rewards for your verified actions',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),
              _buildMainButton(theme),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(
    BuildContext context,
    ThemeData theme, {
    required bool isOnImage,
  }) {
    final textColor = isOnImage ? Colors.white : theme.textTheme.bodyMedium?.color;

    return GestureDetector(
      onTap: onSkipPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isOnImage ? Colors.black.withOpacity(0.3) : theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          'Skip',
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 13.sp,
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRichTitle(
    BuildContext context,
    ThemeData theme, {
    bool isSteps = false,
  }) {
    final colorScheme = theme.colorScheme;

    return RichText(
      textAlign: isSteps ? TextAlign.start : TextAlign.center,
      text: TextSpan(
        style: AppTypography.h1.copyWith(
          fontSize: isSteps ? 30.sp : 28.sp,
          fontWeight: FontWeight.w900,
          color: theme.textTheme.headlineMedium?.color,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        children: [
          TextSpan(text: item.title),
          if (item.highlightedTitle.isNotEmpty)
            TextSpan(
              text: ' ${item.highlightedTitle}',
              style: AppTypography.h1.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          if (item.suffixTitle != null) TextSpan(text: ' ${item.suffixTitle}'),
        ],
      ),
    );
  }

  Widget _buildMainButton(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onNextPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.buttonText,
              style: AppTypography.button.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
