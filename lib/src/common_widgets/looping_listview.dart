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
