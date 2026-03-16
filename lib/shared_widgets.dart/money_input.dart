import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final TextEditingController? controller;

  const MoneyInput({super.key, this.onChanged, this.style, this.controller});

  @override
  State<MoneyInput> createState() => _MoneyInputState();
}

class _MoneyInputState extends State<MoneyInput> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;
  bool _ownsController = false;
  String _digits = '';

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(_syncFromController);
    _focusNode.addListener(() => setState(() {}));
  }

  void _syncFromController() {
    final incoming = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (incoming != _digits) {
      setState(() => _digits = incoming);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    final capped = cleaned.length > 4 ? cleaned.substring(0, 4) : cleaned;
    if (capped != _digits) {
      setState(() => _digits = capped);
      _controller.value = TextEditingValue(
        text: capped,
        selection: TextSelection.collapsed(offset: capped.length),
      );
      widget.onChanged?.call(_displayValue);
    }
  }

  String get _displayValue => _digits.isEmpty ? '00' : _digits;
  bool get _isEmpty => _digits.isEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.requestFocus();
          });
        } else {
          _focusNode.requestFocus();
        }
      },
      child: Stack(
        children: [
          IgnorePointer(
            child: Opacity(
              opacity: 0,
              child: SizedBox(
                width: 1,
                height: 1,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: _onChanged,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                  ),
                  style: const TextStyle(fontSize: 1),
                  cursorWidth: 0,
                  showCursor: false,
                  enableInteractiveSelection: false,
                ),
              ),
            ),
          ),
          Text(
            _displayValue,
            style:
                (widget.style ??
                        const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                        ))
                    .copyWith(color: _isEmpty ? Colors.grey.shade400 : null),
          ),
        ],
      ),
    );
  }
}
