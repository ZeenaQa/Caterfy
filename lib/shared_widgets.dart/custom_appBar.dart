import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title = '',
    this.titleSize = 20,
    PreferredSize? bottom,
    this.onPressed,
    this.noBackButton = false,
    this.content,
  });

  final String title;
  final double titleSize;
  final VoidCallback? onPressed;
  final bool noBackButton;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          spacing: 10,
          children: [
            if (title.isNotEmpty)
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
            if (content != null) content!,
          ],
        ),
      ),
      leadingWidth: 74,
      titleSpacing: -3,
      leading: noBackButton
          ? null
          : IconButton(
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
                    child: Center(child: BackButtonIcon()),
                  ),
                ),
              ),
              onPressed: () {
                if (onPressed != null) {
                  onPressed!();
                  return;
                }
                Navigator.of(context).maybePop();
              },
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
