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
            Icon(icon, color: colors.onSurfaceVariant, size: 21),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: colors.onSurface,
              ),
            ),
            Spacer(),
            if (rightText != null)
              Text(
                rightText!,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurfaceVariant,
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
