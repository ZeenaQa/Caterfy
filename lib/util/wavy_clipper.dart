import 'package:flutter/material.dart';

class WavyClipper extends CustomClipper<Path> {
  final double waveHeight;

  WavyClipper({this.waveHeight = 20});

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(0, 0);
    path.lineTo(0, height - waveHeight);

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

    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
