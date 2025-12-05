import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OverlapHeartButton extends StatefulWidget {
  const OverlapHeartButton({
    super.key,
    this.size = 18,
    required this.isFavorite,
    required this.onTap,
  });

  final double size;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  State<OverlapHeartButton> createState() => _OverlapHeartButtonState();
}

class _OverlapHeartButtonState extends State<OverlapHeartButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController _tiltController;
  late Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        );

    _tiltController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _tiltAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.06), weight: 25),
          TweenSequenceItem(tween: Tween(begin: -0.06, end: 0.06), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 0.06, end: 0.0), weight: 25),
        ]).animate(
          CurvedAnimation(parent: _tiltController, curve: Curves.easeInOut),
        );
  }

  @override
  void didUpdateWidget(covariant OverlapHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isFavorite && !oldWidget.isFavorite) {
      _scaleController.reset();
      _scaleController.forward();
    }

    if (!widget.isFavorite && oldWidget.isFavorite) {
      _tiltController.reset();
      _tiltController.forward();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: RotationTransition(
            turns: _tiltAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SvgPicture.asset(
                'assets/icons/heart_icon.svg',
                height: widget.size,
                width: widget.size,
                theme: SvgTheme(
                  currentColor: widget.isFavorite
                      ? const Color(0xFFF0F0F0)
                      : Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
