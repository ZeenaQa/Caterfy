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
    final colors = Theme.of(context).colorScheme;
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
        suffixIconConstraints: BoxConstraints(maxWidth: 60),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: colors.onSurfaceVariant,
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
    final colors = Theme.of(context).colorScheme;
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
                  color: hasError ? colors.error : colors.onSurface,
                ),
              ),
              if (hasError)
                Text(
                  " - ${errorText ?? ''}",
                  style: TextStyle(
                    color: colors.error,
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
    final colors = Theme.of(context).colorScheme;
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
                  color: hasError ? colors.error : colors.onSurface,
                ),
              ),
              if (hasError)
                Text(
                  " - ${errorText ?? ''}",
                  style: TextStyle(
                    color: colors.error,
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
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return IntlPhoneField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: false,
        errorStyle: const TextStyle(height: 0, fontSize: 0),

        errorBorder: theme.inputDecorationTheme.enabledBorder,
        focusedErrorBorder: theme.inputDecorationTheme.focusedBorder,
      ),

      disableLengthCheck: false,

      initialCountryCode: 'JO',
      onChanged: (phone) {
        onChanged(phone.completeNumber);
      },
<<<<<<< HEAD
      style: TextStyle(color: Colors.black),
      flagsButtonMargin: EdgeInsets.only(left: 10),
      showCountryFlag: false,
=======
      style: TextStyle(color: colors.onSecondary),
>>>>>>> main
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
    final colors = Theme.of(context).colorScheme;
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
                      color: hasError ? colors.error : colors.onSurface,
                    ),
                  ),
                if (hasError)
                  Text(
                    " - ${errorText ?? ''}",
                    style: TextStyle(
                      color: colors.error,
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
