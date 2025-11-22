import 'package:flutter/material.dart';

class DrawerBtn extends StatelessWidget {
  final String title;
  final ColorScheme colors;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSelected;
  const DrawerBtn({
    super.key,
    required this.colors,
    required this.title,
    required this.onPressed,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: colors.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: () {
          onPressed();
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              spacing: 12,
              children: [
                icon != null ? Icon(icon) : SizedBox(),
                Text(
                  title,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                if (isSelected) ...[
                  Icon(
                    Icons.check,
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: 0),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
