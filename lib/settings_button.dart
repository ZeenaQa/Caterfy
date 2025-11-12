import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.title,
    this.onTap,
    this.rightText,
    this.icon,
    this.isLastItem = false,
  });

  final String title;
  final VoidCallback? onTap;
  final String? rightText;
  final IconData? icon;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 15, bottom: 13),
        decoration: BoxDecoration(
          border: isLastItem
              ? null
              : Border(bottom: BorderSide(color: Color(0xffe2e2e2))),
        ),
        child: Row(
          children: [
            Icon(
              icon ?? Icons.person_outline,
              color: Color(0xff676767),
              size: 23,
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xff242424),
              ),
            ),
            Spacer(),
            if (rightText != null)
              Text(
                rightText!,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            if (rightText != null) SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: Color(0xff676767), size: 17),
          ],
        ),
      ),
    );
  }
}
