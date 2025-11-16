import 'package:caterfy/shared_widgets.dart/three_bounce.dart';
import 'package:flutter/material.dart';

class FilledBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool stretch;
  final String title;
  final double verticalPadding;
  final double horizontalPadding;

  const FilledBtn({
    super.key,
    required this.onPressed,
    required this.title,
    this.isLoading = false,
    this.stretch = true,
    this.verticalPadding = 15,
    this.horizontalPadding = 25,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: stretch ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          shadowColor: Colors.transparent,
        ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLoading ? 0.0 : 1.0,
              child: Text(
                title,
                style: TextStyle(color: colors.onPrimary, fontSize: 15),
              ),
            ),
            if (isLoading) ThreeBounce(),
          ],
        ),
      ),
    );
  }
}
