import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

//------------------- Custom Text Field -------------------
class CustomTextField extends StatelessWidget {
  final String? value;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool readOnly;
  final int? maxLines;


  const CustomTextField({
    super.key,
    this.value,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.onChanged,
    this.errorText,
    this.readOnly = false, 
     this.maxLines=1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 15),
      controller: value != null
    ? TextEditingController.fromValue(
        TextEditingValue(
          text: value!,
          selection: TextSelection.collapsed(offset: value!.length),
        ),
      )
    : null,

      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
       maxLines: maxLines,
      enableInteractiveSelection: !readOnly,
      onChanged: readOnly ? null : onChanged,
      focusNode: readOnly ? AlwaysDisabledFocusNode() : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        hintText: value == null ? hint : null,
        suffixIcon: suffix,
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
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
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: colors.onSurfaceVariant,
                size: 20,
              ),
              onPressed: _toggleVisibility,
            ),
          ],
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
    this.readOnly = false,
    this.value,
    this.maxLines = 1,
  });

  final Function onChanged;
  final String? hint;
  final String? label;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool readOnly;
  final String? value;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              SizedBox(width: 15),
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
          value: value,
          hint: hint,
           maxLines: maxLines,
          errorText: errorText,
          readOnly: readOnly,
          onChanged: readOnly ? null : (value) => onChanged(value),
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
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              SizedBox(width: 15),
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
        hintStyle: TextStyle(fontSize: 15),
        prefixStyle: TextStyle(fontSize: 15),
        suffixStyle: TextStyle(fontSize: 15),
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
      style: TextStyle(color: colors.onSecondary),
    );
  }
}

/// ------------------- Labeled Phone Field -------------------
class LabeledPhoneField extends StatelessWidget {
  const LabeledPhoneField({
    super.key,
    required this.onChanged,
    this.label,
    this.hintText,
    this.errorText,
  });

  final Function(String) onChanged;
  final String? label;
  final String? hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(width: 15),
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
        CustomPhoneField(
          hintText: hintText ?? l10.enterPhoneNumber,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
