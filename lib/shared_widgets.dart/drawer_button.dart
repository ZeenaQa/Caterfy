import 'package:flutter/material.dart';

class DrawerBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSelected;
  final Widget? content;
  const DrawerBtn({
    super.key,
    this.title = '',
    required this.onPressed,
    this.icon,
    this.isSelected = false,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
            padding: const EdgeInsetsDirectional.only(start: 5),
            child: Row(
              spacing: 12,
              children: [
                icon != null ? Icon(icon) : SizedBox(),
                if (content == null)
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  content!,
                Spacer(),

                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: !isSelected
                        ? Border.all(color: colors.outline, width: 2)
                        : null,
                    shape: BoxShape.circle,
                    color: isSelected ? colors.primary : null,
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? colors.surfaceContainer : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
