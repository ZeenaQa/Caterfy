import 'package:flutter/material.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppBar({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
      leadingWidth: 65,
      titleSpacing: 0,
      leading: IconButton(
        padding: EdgeInsets.zero,
        icon: Material(
          color: Colors.white,
          shape: CircleBorder(side: BorderSide(color: Color(0xffe2e2e2))),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(child: BackButtonIcon()),
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
