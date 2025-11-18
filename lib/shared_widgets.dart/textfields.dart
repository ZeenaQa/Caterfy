import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

//------------------- Custom Text Field -------------------
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
      style: TextStyle(fontSize: 15),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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

/// ------------------- Password Text Field -------------------
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
      style: TextStyle(fontSize: 15),
      obscureText: _obscure,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
        suffixIconConstraints: BoxConstraints(maxWidth: 60),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: Color(0xff9c9c9c),
              size: 20,
            ),
            onPressed: _toggleVisibility,
          ),
        ),
      ),
    );
  }
}

/// ------------------- Labeled Text Field -------------------
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
                  fontSize: 13,
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

/// ------------------- Labeled Password Field -------------------
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
                  fontSize: 13,
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

/// ------------------- Custom Phone Field -------------------
class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    required this.onChanged,
    this.hintText = "Phone Number",
  });

  final Function(String) onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: hintText,
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
      initialCountryCode: 'JO',
      disableLengthCheck: false,
      onChanged: (phone) {
        onChanged(phone.completeNumber);
      },
      style: const TextStyle(color: Colors.black),
    );
  }
}

/// ------------------- Labeled Phone Field -------------------
class LabeledPhoneField extends StatelessWidget {
  const LabeledPhoneField({
    super.key,
    required this.onChanged,
    this.label,
    this.hintText = "Phone Number",
    this.errorText,
  });

  final Function(String) onChanged;
  final String? label;
  final String hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || hasError)
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 6),
            child: Row(
              children: [
                if (label != null)
                  Text(
                    label!,
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
        CustomPhoneField(hintText: hintText, onChanged: onChanged),
      ],
    );
  }
}
