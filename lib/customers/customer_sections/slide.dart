import 'package:flutter/material.dart';

class SlidingAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget child;

  SlidingAppBarDelegate({required this.expandedHeight, required this.child});

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // shrinkOffset = how much we've scrolled up

    final double delta = maxExtent - shrinkOffset;
    final double translateY = -shrinkOffset; // move up as we scroll

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Opacity(opacity: delta > 0 ? 1 : 0, child: child),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
