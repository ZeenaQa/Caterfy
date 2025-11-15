import 'package:flutter/material.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppBar({super.key, this.title, PreferredSize? bottom});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      leadingWidth: 78,
      titleSpacing: -7,
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
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
