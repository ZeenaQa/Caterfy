import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutlinedBtn extends StatelessWidget {
  const OutlinedBtn({
    super.key,
    required this.onPressed,
    required this.title,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.icon,
    this.customSvgIcon,
  });

  final Function onPressed;
  final String title;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final IconData? icon;
  final SvgPicture? customSvgIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding ?? 0,
        bottom: bottomPadding ?? 0,
        left: leftPadding ?? 0,
        right: rightPadding ?? 0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: BorderSide(color: Color(0xff7a7a7a), width: 1),
          shadowColor: Colors.transparent,
        ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        onPressed: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: Color(0xff2c2c2c), size: 18)
            else if (customSvgIcon != null)
              customSvgIcon!,
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Color(0xff2c2c2c),
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
