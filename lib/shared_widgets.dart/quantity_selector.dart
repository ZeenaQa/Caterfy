import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuantitySelector extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final ValueChanged<int>? onChanged;
  final double height;

  const QuantitySelector({
    super.key,
    this.initialValue = 1,
    this.minValue = 1,
    this.maxValue = 99,
    this.onChanged,
    this.height = 50,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      setState(() {
        _currentValue++;
      });
      widget.onChanged?.call(_currentValue);
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      setState(() {
        _currentValue--;
      });
      widget.onChanged?.call(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: widget.height,
      // padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colors.onInverseSurface,
        border: Border.all(color: colors.outline, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _currentValue > widget.minValue ? _decrement : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Container(
              width: 43,
              height: 32,
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.minus,
                size: 19,
                color: _currentValue > widget.minValue
                    ? colors.primary
                    : colors.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: AnimatedFlipCounter(
              value: _currentValue,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          InkWell(
            onTap: _currentValue < widget.maxValue ? _increment : null,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              width: 43,
              height: 32,
              alignment: Alignment.center,
              child: Icon(
                FontAwesomeIcons.plus,
                size: 19,
                color: _currentValue < widget.maxValue
                    ? colors.primary
                    : colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// USAGE EXAMPLE:
// 
// RollingQuantitySelector(
//   initialValue: 1,
//   minValue: 0,
//   maxValue: 50,
//   onChanged: (value) {
//     print('Quantity changed to: $value');
//     // Update your cart, state, etc.
//   },
// )