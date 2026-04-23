import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.title,
    this.onTap,
    this.rightText,
    this.icon,
    this.isLastItem = false,
    this.iconSize = 21,
  });

  final String title;
  final VoidCallback? onTap;
  final String? rightText;
  final IconData? icon;
  final bool isLastItem;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 17, bottom: 15),
        decoration: BoxDecoration(
          border: isLastItem
              ? null
              : Border(bottom: BorderSide(color: colors.outline)),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.onSurfaceVariant, size: iconSize),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: colors.onSurface,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 20),
            if (rightText != null)
              Text(
                rightText!,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurfaceVariant,
                  // overflow: TextOverflow.ellipsis
                ),
              ),
            if (rightText != null) SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: colors.onSurfaceVariant,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}
