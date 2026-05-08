import 'package:flutter/material.dart';

class WheelSelector<T> extends StatefulWidget {
  const WheelSelector({
    super.key,
    required this.items,
    required this.initialItem,
    required this.onChanged,
    required this.itemLabel,
    this.itemExtent = 44.0,
    this.visibleItems = 5,
  });

  final List<T> items;
  final T initialItem;
  final ValueChanged<T> onChanged;
  final String Function(T item) itemLabel;
  final double itemExtent;
  final int visibleItems;

  @override
  State<WheelSelector<T>> createState() => _WheelSelectorState<T>();
}

class _WheelSelectorState<T> extends State<WheelSelector<T>> {
  late final FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    print(widget.initialItem);
    _selectedIndex = widget.items
        .indexOf(widget.initialItem)
        .clamp(0, widget.items.length - 1);
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _wheelHeight => widget.itemExtent * widget.visibleItems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _wheelHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: (_wheelHeight - widget.itemExtent) / 2,
            left: 16,
            right: 16,
            height: widget.itemExtent,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: _wheelHeight * 0.35,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: _wheelHeight * 0.35,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: widget.itemExtent,
            perspective: 0.003,
            diameterRatio: 1.8,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() => _selectedIndex = index);
              widget.onChanged(widget.items[index]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.items.length,
              builder: (context, index) {
                final isSelected = index == _selectedIndex;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 180),
                    style: TextStyle(
                      fontSize: isSelected ? 16 : 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.35),
                    ),
                    child: Text(widget.itemLabel(widget.items[index])),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
