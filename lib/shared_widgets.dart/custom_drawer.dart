import 'package:flutter/material.dart';

Future<T?> openDrawer<T>(
  BuildContext context, {
  required Widget child,
  double? height,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  double borderRadius = 24.0,
  EdgeInsets? padding,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ModernDrawer(
      height: height,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      padding: padding,
      child: child,
    ),
  );
}

class ModernDrawer extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets? padding;

  const ModernDrawer({
    super.key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: height, // Only constrain height if explicitly provided
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // KEY: Shrink to fit children
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content - wrap only if needed
          Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
