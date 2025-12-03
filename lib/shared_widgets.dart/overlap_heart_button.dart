import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OverlapHeartButton extends StatelessWidget {
  const OverlapHeartButton({super.key, this.size = 18});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            FontAwesomeIcons.heart, // outline (border)
            size: size + 2,
            color: const Color(0xFFE7E7E7), // border color
          ),
          Opacity(
            opacity: 0.5,
            child: Icon(
              FontAwesomeIcons.solidHeart, // filled
              size: size,
              color: Colors.black, // fill color
            ),
          ),
        ],
      ),
    );
  }
}
