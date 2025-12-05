import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OverlapHeartButton extends StatelessWidget {
  const OverlapHeartButton({
    super.key,
    this.size = 18,
    required this.isFavorite,
    required this.onTap,
  });

  final double size;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              FontAwesomeIcons.heart,
              size: size + 2,
              color: const Color(0xFFE7E7E7),
            ),

            // Fill
            Opacity(
              opacity: isFavorite ? 1 : 0.5,
              child: Icon(
                FontAwesomeIcons.solidHeart,
                size: size,
                color: isFavorite
                    ? const Color(0xFFF7584D)
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
