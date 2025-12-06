import 'package:flutter/material.dart';

class OutlinedIconBtn extends StatelessWidget {
  const OutlinedIconBtn({
    super.key,
    required this.child,
    this.onPressed,
    this.size = 40.0,
    this.color,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Material(
        color: colors.onInverseSurface,
        shape: CircleBorder(side: BorderSide(color: colors.outline)),
        clipBehavior: Clip.antiAlias,
        child: IconTheme(
          data: IconThemeData(size: 22, color: color ?? colors.onSurface),
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: child),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
