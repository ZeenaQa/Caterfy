import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleSize = 20,
    PreferredSize? bottom,
    this.onPressed,
  });

  final String? title;
  final double titleSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w600),
      ),
      leadingWidth: 74,
      titleSpacing: -3,
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: Material(
          color: Colors.white,
          shape: CircleBorder(side: BorderSide(color: Color(0xffe2e2e2))),
          clipBehavior: Clip.antiAlias,
          child: IconTheme(
            data: IconThemeData(size: 22),
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
