import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ThreeBounce extends StatelessWidget {
  const ThreeBounce({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SpinKitThreeBounce(color: colors.onPrimary, size: 17);
  }
}
