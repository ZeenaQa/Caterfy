import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ThreeBounce extends StatelessWidget {
  final double size;
  const ThreeBounce({super.key, this.size = 17});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SpinKitThreeBounce(color: colors.onPrimary, size: size);
  }
}
