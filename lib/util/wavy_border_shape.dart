import 'package:flutter/material.dart';

class WavyShapeBorder extends ShapeBorder {
  final double waveHeight;

  WavyShapeBorder({this.waveHeight = 20});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: waveHeight);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final width = rect.width;
    final height = rect.height;

    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.left, height - waveHeight);

    var firstControlPoint = Offset(width / 4, height + waveHeight);
    var firstEndPoint = Offset(width / 2, height - waveHeight);

    var secondControlPoint = Offset(3 * width / 4, height - 3 * waveHeight);
    var secondEndPoint = Offset(width, height - waveHeight);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(width, rect.top);
    path.close();

    return path;
  }

  // Required override, usually same as getOuterPath for solid shapes
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // no extra painting needed here
  }

  @override
  ShapeBorder scale(double t) {
    return WavyShapeBorder(waveHeight: waveHeight * t);
  }
}
