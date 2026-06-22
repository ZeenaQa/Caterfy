import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomThreeLineSpinner extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const CustomThreeLineSpinner({
    super.key,
    this.size = 50.0,
    this.strokeWidth = 4.0,
  });

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
      duration: const Duration(milliseconds: 1150),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _TalabatStylePainter(
              progress: _controller.value,
              color: colors.primary,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _TalabatStylePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _TalabatStylePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final curveValue = Curves.easeInOutCubic.transform(progress);
    final globalRotation = curveValue * 2 * math.pi;

    for (int i = 0; i < 3; i++) {
      final baseOffset = i * (2 * math.pi / 3);
      final speedFactor = math.sin(progress * math.pi);
      final shrinkCurve = math.pow(speedFactor, 3.5);
      final currentLength = 0.35 + (shrinkCurve * 1.2);
      final startAngle = globalRotation + baseOffset;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        currentLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_TalabatStylePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
