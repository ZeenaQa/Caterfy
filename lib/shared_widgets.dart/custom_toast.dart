import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showCustomToast({
  required BuildContext context,
  required String message,
  String position = 'top',
  int durationSeconds = 3,

  
  
  ToastificationType type = ToastificationType.info,
}) {
  Alignment alignment;

  switch (position.toLowerCase()) {
    case 'bottom':
      alignment = Alignment.bottomCenter;
      break;
    case 'center':
      alignment = Alignment.center;
      break;
    case 'top':
    default:
      alignment = Alignment.topCenter;
      break;
  }
    final colors = Theme.of(context).colorScheme;
  toastification.show(
    backgroundColor:colors.surface,
     description: Text(
      message,
      style: TextStyle(color: colors.onSurface),
    ),
    context: context,

    alignment: alignment,
    autoCloseDuration: Duration(seconds: durationSeconds),
    animationDuration: Duration(milliseconds: 220),
    dismissDirection: DismissDirection.up,
    borderRadius: BorderRadius.circular(20),
    type: type,
    style: ToastificationStyle.flat,
  );
}
