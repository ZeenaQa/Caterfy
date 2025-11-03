import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LogoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      title: SvgPicture.asset('images/logo.svg', height: 40),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
