import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Widget chiild;
  final VoidCallback onPressed;

  const AuthButton({super.key, required this.chiild, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: chiild,
      ),
    );
  }
}
