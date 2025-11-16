import 'package:flutter/material.dart';

Future<void> showMyDialog(
  BuildContext context, {
  required String title,
  required String content,
  String cancelText = 'Cancel',
  String confirmText = 'OK',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 210),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Container(
            width: screenWidth * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Log out",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(content),
                const SizedBox(height: 24),
                Row(
                  children: [
                    DialogBtn(
                      isCancel: true,
                      function: () {
                        Navigator.of(context).pop();
                        if (onCancel != null) onCancel();
                      },
                      color: Colors.green,
                      text: cancelText,
                    ),
                    const SizedBox(width: 10),
                    DialogBtn(
                      isCancel: false,
                      function: () {
                        Navigator.of(context).pop();
                        if (onConfirm != null) onConfirm();
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
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = Curves.easeInOut.transform(animation.value);

      return Transform.translate(
        offset: Offset(0, (1 - curvedAnimation) * 50), // slide up
        child: Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: 0.95 + (curvedAnimation * 0.05), // scale 0.95 → 1.0
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
  const DialogBtn({
    super.key,
    required this.color,
    required this.text,
    this.function,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(vertical: 10),
          backgroundColor: isCancel ? Colors.transparent : Color(0xFF9359FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: BorderSide(color: Color(0xffe3e3e3), width: isCancel ? 1 : 0),
          ),
          shadowColor: Colors.transparent,
        ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(color: isCancel ? Color(0xff2c2c2c) : null),
        ),
      ),
    );
  }
}
