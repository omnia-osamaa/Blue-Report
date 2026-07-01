import 'package:flutter/material.dart';

class RevealClipper extends CustomClipper<Path> {
  final double revealPercent;

  const RevealClipper({required this.revealPercent});

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final currentRadius = maxRadius * revealPercent;

    final path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: currentRadius));

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

