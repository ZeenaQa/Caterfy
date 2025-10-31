import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final String? hiint;
  const CustomTextField({
    super.key,
    this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.onChanged,
    this.hiint,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(255, 95, 117, 121);

    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,

      style: const TextStyle(color: Color(0xFF577A80)),
      decoration: InputDecoration(
        hintText: hiint,
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 182, 198, 200)),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 182, 198, 200),
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Color(0xFFf2f2f2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String labelText;

  final ValueChanged<String>? onChanged;

  const PasswordTextField({
    super.key,
    this.labelText = "Password",

    this.onChanged, // add this
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(255, 95, 117, 121);

    return TextField(
      obscureText: _obscure,

      style: const TextStyle(color: Colors.black),
      cursorColor: Color.fromARGB(255, 182, 198, 200),
      onChanged: widget.onChanged, // use widget.onChanged here
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 182, 198, 200)),
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(255, 182, 198, 200),
        ),
        filled: true,
        fillColor: Color(0xFFf2f2f2),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: borderColor,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
