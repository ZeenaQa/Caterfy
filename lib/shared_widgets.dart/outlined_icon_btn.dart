import 'package:flutter/material.dart';

class OutlinedIconBtn extends StatelessWidget {
  const OutlinedIconBtn({super.key, required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

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
          data: IconThemeData(size: 22, color: colors.onSurface),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(child: Icon(icon)),
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
