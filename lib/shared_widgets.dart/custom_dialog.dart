import 'package:caterfy/shared_widgets.dart/three_bounce.dart';
import 'package:flutter/material.dart';

Future<bool?> showCustomDialog(
  BuildContext context, {
  required String title,
  required String content,
  String cancelText = 'Cancel',
  String confirmText = 'OK',
  Future<void> Function()? onConfirmAsync,
  bool popAfterAsync = true,
  VoidCallback? onCancel,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final colors = Theme.of(context).colorScheme;
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: colors.onSurface,
    transitionDuration: const Duration(milliseconds: 210),
    pageBuilder: (context, animation, secondaryAnimation) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setState) => Center(
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: TextStyle(fontSize: 15, color: Color(0xff656565)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      DialogBtn(
                        isCancel: true,
                        function: () {
                          if (!isLoading) {
                            Navigator.of(context).pop(false);
                            if (onCancel != null) onCancel();
                          }
                        },
                        color: Colors.green,
                        text: cancelText,
                        isLoading: false,
                      ),
                      const SizedBox(width: 10),
                      DialogBtn(
                        isLoading: isLoading,
                        isCancel: false,
                        function: () async {
                          if (isLoading) return;
                          setState(() => isLoading = true);

                          await onConfirmAsync!();

                          if (context.mounted && popAfterAsync) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        color: Colors.green,
                        text: confirmText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = Curves.easeInOut.transform(animation.value);

      return Transform.translate(
        offset: Offset(0, (1 - curvedAnimation) * 50),
        child: Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: 0.95 + (curvedAnimation * 0.05),
            child: child,
          ),
        ),
      );
    },
  );
}

class DialogBtn extends StatelessWidget {
  final bool isCancel;
  final Color color;
  final String text;
  final VoidCallback? function;
  final bool isLoading;
  const DialogBtn({
    super.key,
    required this.color,
    required this.text,
    this.function,
    this.isCancel = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(vertical: 10),
          backgroundColor: isCancel ? Colors.transparent : colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: colors.outline, width: isCancel ? 1 : 0),
          ),
          shadowColor: Colors.transparent,
        ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        onPressed: function,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: isLoading && !isCancel ? 0.0 : 1.0,
              child: Text(
                text,
                style: TextStyle(
                  color: isCancel ? colors.onSecondary : colors.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            if (isLoading && !isCancel) ThreeBounce(size: 15),
          ],
        ),
      ),
    );
  }
}
