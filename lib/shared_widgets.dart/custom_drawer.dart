import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

Future<T?> openDrawer<T>(
  BuildContext context, {
  required Widget child,
  double? height,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  double borderRadius = 34.0,
  EdgeInsets? padding,
  String title = '',
  bool isStack = false,
  bool showCloseBtn = true,
  bool accountForKeyboard = false,
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
      title: title,
      isStack: isStack,
      showCloseBtn: showCloseBtn,
      accountForKeyboard: accountForKeyboard,
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
  final String title;
  final bool isStack;
  final bool showCloseBtn;
  final bool accountForKeyboard;

  const ModernDrawer({
    super.key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.borderRadius = 34.0,
    this.padding,
    this.title = '',
    this.isStack = false,
    this.showCloseBtn = true,
    this.accountForKeyboard = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: accountForKeyboard
            ? max(MediaQuery.of(context).viewInsets.bottom - 16, 0)
            : 0,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 30),
        width: double.infinity,
        height: height, // Only constrain height if explicitly provided
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
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
            if (!isStack) ...[
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 3),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content - wrap only if needed
              if (showCloseBtn)
                Row(
                  children: [
                    SizedBox(width: 12),
                    OutlinedIconBtn(
                      onPressed: () => Navigator.of(context).pop(),
                      size: 40,
                      child: Icon(
                        FontAwesomeIcons.x,
                        color: colors.onSurface,
                        size: 14,
                      ),
                    ),
                    SizedBox(width: 10),
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              Padding(
                padding: padding ?? const EdgeInsets.only(bottom: 15),
                child: child,
              ),
            ] else
              Stack(
                children: [
                  Padding(
                    padding: padding ?? const EdgeInsets.only(bottom: 15),
                    child: child,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 3),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color(0xffe5e5e5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 12),
                          OutlinedIconBtn(
                            onPressed: () => Navigator.of(context).pop(),
                            size: 40,
                            child: Icon(
                              FontAwesomeIcons.x,
                              color: colors.onSurface,
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 10),
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // Content - wrap only if needed
                ],
              ),
          ],
        ),
      ),
    );
  }
}
