import 'package:flutter/material.dart';

class SuccessCircle extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Widget? child;

  const SuccessCircle({
    super.key,
    this.size = 140,
    required this.primaryColor,
    this.child,
  });

  @override
  State<SuccessCircle> createState() => _SuccessCircleState();
}

class _SuccessCircleState extends State<SuccessCircle>
    with TickerProviderStateMixin {
  late AnimationController _outerController;
  late AnimationController _innerController;
  late AnimationController _scaleController;

  late Animation<double> _outerAnimation;
  late Animation<double> _innerAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _outerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _outerAnimation = CurvedAnimation(
      parent: _outerController,
      curve: Curves.easeOutBack,
    );

    _innerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _innerAnimation = CurvedAnimation(
      parent: _innerController,
      curve: Curves.easeOutBack,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _outerController.forward();
    await _innerController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _scaleController.forward();
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _outerAnimation,
            builder: (context, child) => Transform.scale(
              scale: _outerAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _innerAnimation,
            builder: (context, child) => Transform.scale(
              scale: _innerAnimation.value,
              child: Container(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size * 0.5,
                height: widget.size * 0.5,
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
