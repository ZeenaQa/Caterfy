import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomThreeLineSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const CustomThreeLineSpinner({
    Key? key,
    this.size = 50.0,
    this.color = const Color(0xFF9359FF),
    this.strokeWidth = 3.0,
  }) : super(key: key);

  @override
  State<CustomThreeLineSpinner> createState() => _CustomThreeLineSpinnerState();
}

class _CustomThreeLineSpinnerState extends State<CustomThreeLineSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ThreeLineSpinnerPainter(
              progress: _controller.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _ThreeLineSpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ThreeLineSpinnerPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3.5;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw three lines at 120-degree intervals
    for (int i = 0; i < 3; i++) {
      // Base rotation angle
      final baseAngle = (progress * 2 * math.pi) + (i * 2 * math.pi / 3);

      // Create slithering effect by modulating the line length
      // Each line has a phase offset so they slither independently
      final phaseOffset = i * (2 * math.pi / 3);
      final slitherProgress = (progress * 2 * math.pi * 2) + phaseOffset;

      // Length varies between 0.15 and 0.5 radians (creating the slither effect)
      final minLength = 0.3;
      final maxLength = 0.9;
      final currentLength =
          minLength +
          (maxLength - minLength) * ((math.sin(slitherProgress) + 1) / 2);

      // Offset the center of the line slightly for more dynamic movement
      final centerOffset = math.cos(slitherProgress * 1.5) * 0.1;

      // Calculate start and end points for each line
      final startAngle = baseAngle + centerOffset - currentLength / 2;
      final endAngle = baseAngle + centerOffset + currentLength / 2;

      // Draw curved arc instead of straight line
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, startAngle, endAngle - startAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(_ThreeLineSpinnerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Usage example:
// CustomThreeLineSpinner()
// or with custom size:
// CustomThreeLineSpinner(size: 60.0, strokeWidth: 4.0)
