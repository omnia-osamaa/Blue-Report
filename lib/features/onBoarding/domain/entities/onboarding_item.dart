import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  final String title;
  final String highlightedTitle;
  final String? suffixTitle;
  final String description;
  final String imagePath;
  final String buttonText;
  final bool showSkip;
  final bool isStepPage;

  const OnboardingItem({
    required this.title,
    required this.highlightedTitle,
    this.suffixTitle,
    required this.description,
    required this.imagePath,
    required this.buttonText,
    this.showSkip = false,
    required this.isStepPage,
  });

  @override
  List<Object?> get props => [
    title,
    highlightedTitle,
    suffixTitle,
    description,
    imagePath,
    buttonText,
    showSkip,
    isStepPage,
  ];
}

