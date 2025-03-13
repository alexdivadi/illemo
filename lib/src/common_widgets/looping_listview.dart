import 'package:flutter/material.dart';

class LoopingListView extends StatelessWidget {
  const LoopingListView(
      {super.key,
      required this.children,
      this.onSelectedItemChanged,
      this.direction = Axis.horizontal,
      this.controller,
      this.itemExtent = 200});

  final List<Widget> children;
  final void Function(int index)? onSelectedItemChanged;
  final Axis direction;
  final ScrollController? controller;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
      diameterRatio: 3,
      perspective: 0.001,
      useMagnifier: true,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildLoopingListDelegate(children: children),
    );
  }
}

extension LoopingListScrollController on ScrollController {
  /// Animate to the given index in a looping list.
  ///  - [index] is the index to scroll to.
  ///  - [itemExtent] is the height of each item in the list.
  ///  - [itemCount] is the number of items in the list.
  ///  - [duration] is the duration of the animation.
  ///  - [curve] is the curve of the animation.
  ///
  /// Uses an algorithm to determine the shortest path to the target index.
  void animateToItem(int index,
      {required double itemExtent,
      required int itemCount,
      required Duration duration,
      required Curve curve}) {
    final currentIndex = (offset / itemExtent).round() % itemCount;
    final difference = (currentIndex - index).abs() > itemCount / 2
        ? currentIndex - (index + (currentIndex - index).sign * itemCount)
        : currentIndex - index;
    final target = (offset / itemExtent - difference).round() * itemExtent;
    animateTo(target, duration: duration, curve: curve);
  }
}
