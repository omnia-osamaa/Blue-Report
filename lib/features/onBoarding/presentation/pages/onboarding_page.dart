import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:general_app/core/theme/app_images.dart';
import 'package:general_app/core/routes/routes.dart';
import '../bloc/onboarding_cubit.dart';
import '../widgets/onboarding_content.dart';
import '../../domain/entities/onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      title: 'Join us in keeping the',
      highlightedTitle: 'environment',
      suffixTitle: 'clean',
      description:
          'Become a guardian of our rivers. Snap photos of waste, earn points, and make a real impact today.',
      imagePath: AppImages.onBoard1,
      buttonText: 'Next Step',
      showSkip: true,
      isStepPage: false,
    ),
    OnboardingItem(
      title: 'Three simple',
      highlightedTitle: 'steps.',
      description:
          'Join the global movement to clean our rivers and earn rewards.',
      imagePath: AppImages.onBoarding1,
      buttonText: 'Next Step',
      showSkip: true,
      isStepPage: true,
    ),
    OnboardingItem(
      title: 'Make a Splash',
      highlightedTitle: 'for the Planet',
      description:
          'Your reports turn into real action. Start collecting points and saving our waterways today.',
      imagePath: AppImages.onBoard2,
      buttonText: 'Get Started',
      showSkip: false,
      isStepPage: false,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          Navigator.pushReplacementNamed(context, Routes.login);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? theme.colorScheme.background : Colors.white,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged:
                  (index) => context.read<OnboardingCubit>().pageChanged(index),
              itemBuilder: (context, index) {
                //  Navigating between onBoarding pages
                return OnboardingContent(
                  item: _items[index],
                  currentPage: index,
                  totalPages: _items.length,
                  pageController: _pageController,
                  onNextPressed: () {
                    if (index < _items.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                      );
                    } else {
                      context.read<OnboardingCubit>().complete();
                    }
                  },
                  onSkipPressed: () => context.read<OnboardingCubit>().skip(),
                );
              },
            ),

            Positioned(
              bottom: 110.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _items.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: theme.colorScheme.primary,
                    dotColor: theme.colorScheme.primary.withOpacity(0.15),
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    expansionFactor: 4,
                    spacing: 8.w,
                  ),
                ),
              ),
            ),

            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder: (context, state) {
                if (state is OnboardingLoading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
