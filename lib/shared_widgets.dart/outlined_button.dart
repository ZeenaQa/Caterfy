import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class OutlinedBtn extends StatelessWidget {
  const OutlinedBtn({
    super.key,
    required this.onPressed,
    required this.title,
    this.titleSize = 14,
    this.topPadding,
    this.bottomPadding,
    this.stretch,
    this.leftPadding,
    this.rightPadding,
    this.innerVerticalPadding = 12,
    this.innerHorizontalPadding = 16,
    this.icon,
    this.customSvgIcon,
    this.lighterBorder = false,
    this.borderRadius = 50,
  });

  final Function onPressed;
  final String title;
  final double titleSize;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final double innerVerticalPadding;
  final double innerHorizontalPadding;
  final double borderRadius;
  final IconData? icon;
  final SvgPicture? customSvgIcon;
  final bool lighterBorder;
  final bool? stretch;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding ?? 0,
        bottom: bottomPadding ?? 0,
        left: leftPadding ?? 0,
        right: rightPadding ?? 0,
      ),
      child: SizedBox(
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            minimumSize: Size.zero,
            padding: EdgeInsets.symmetric(
              vertical: innerVerticalPadding,
              horizontal: innerHorizontalPadding,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(max(borderRadius, 0)),
            ),
            side: BorderSide(
              color: lighterBorder ? colors.outline : colors.onSurfaceVariant,
              width: 1,
            ),
          ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
          onPressed: () => onPressed(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(icon, color: colors.onSecondary, size: 18)
              else if (customSvgIcon != null)
                customSvgIcon!,
              if (icon != null || customSvgIcon != null) SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: titleSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
