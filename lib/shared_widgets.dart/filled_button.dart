import 'package:caterfy/shared_widgets.dart/three_bounce.dart';
import 'package:flutter/material.dart';

class FilledBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool stretch;
  final String title;
  final double titleSize;
  final double innerVerticalPadding;
  final double innerHorizontalPadding;
  final double verticalPadding;
  final double horizontalPadding;
  final Widget? content;
  final double loadingSize;

  const FilledBtn({
    super.key,
    required this.onPressed,
    this.title = '',
    this.titleSize = 14,
    this.content,
    this.isLoading = false,
    this.stretch = true,
    this.innerVerticalPadding = 15,
    this.innerHorizontalPadding = 25,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.loadingSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: SizedBox(
        width: stretch ? double.infinity : null,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(
              vertical: innerVerticalPadding,
              horizontal: innerHorizontalPadding,
            ),
            shadowColor: Colors.transparent,
          ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: isLoading ? 0.0 : 1.0,
                child:
                    content ??
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: colors.onPrimary,
                        fontSize: titleSize,
                      ),
                    ),
              ),
              if (isLoading) ThreeBounce(size: loadingSize),
            ],
          ),
        ),
      ),
    );
  }
}
