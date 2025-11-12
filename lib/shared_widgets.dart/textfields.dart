import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const CustomTextField({
    super.key,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,

        suffixIcon: suffix,
        filled: false,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xffe2e2e2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xffadadad), width: 1),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String? hint;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const PasswordTextField({
    super.key,
    this.hint,
    this.onChanged,
    this.errorText,
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
    return TextField(
      obscureText: _obscure,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,

        filled: false,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xffe2e2e2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xffadadad), width: 1),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Color(0xff9c9c9c),
            size: 22,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.onChanged,
    this.hint,
    this.label,
    this.keyboardType,
    this.errorText,
  });

  final Function onChanged;
  final String? hint;
  final String? label;
  final TextInputType? keyboardType;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 6),
          child: Row(
            children: [
              Text(
                label ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: hasError ? Color(0xfffd7a7a) : Color(0xff333333),
                ),
              ),
              if (hasError)
                Text(
                  " - ${errorText ?? ''}",
                  style: TextStyle(
                    color: Color(0xfffd7a7a),
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        CustomTextField(
          onChanged: (value) => onChanged(value),
          hint: hint,
          errorText: errorText,
        ),
      ],
    );
  }
}

class LabeledPasswordField extends StatelessWidget {
  const LabeledPasswordField({
    super.key,

    required this.onChanged,
    this.hint,
    this.label,
    this.errorText,
  });

  final Function onChanged;
  final String? hint;
  final String? label;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 6),
          child: Row(
            children: [
              Text(
                label ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: hasError ? Color(0xfffd7a7a) : Color(0xff333333),
                ),
              ),
              if (hasError)
                Text(
                  " - ${errorText ?? ''}",
                  style: TextStyle(
                    color: Color(0xfffd7a7a),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        PasswordTextField(
          onChanged: (value) => onChanged(value),
          hint: hint,
          errorText: errorText,
        ),
      ],
    );
  }
}
