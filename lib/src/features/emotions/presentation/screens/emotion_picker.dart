import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:illemo/src/common_widgets/looping_listview.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/service/emotion_today_service.dart';

class EmotionPickerScreen extends ConsumerStatefulWidget {
  const EmotionPickerScreen({super.key, this.todaysEmotionLog});

  static const path = "/emotion/pick";
  static const title = "Pick an Emotion";

  final EmotionLog? todaysEmotionLog;

  @override
  ConsumerState<EmotionPickerScreen> createState() => _EmotionPickerScreenState();
}

class _EmotionPickerScreenState extends ConsumerState<EmotionPickerScreen> {
  late ScrollController _controllerHorizontal;
  final Map<Category, ScrollController> _verticalControllers = {};
  final List<Emotion> _selectedEmotions = <Emotion>[];
  Emotion? currentEmotion;

  @override
  void initState() {
    super.initState();
    if (widget.todaysEmotionLog != null) {
      _selectedEmotions.add(widget.todaysEmotionLog!.emotion1);
      if (widget.todaysEmotionLog!.emotion2 != null) {
        _selectedEmotions.add(widget.todaysEmotionLog!.emotion2!);
      }
      if (widget.todaysEmotionLog!.emotion3 != null) {
        _selectedEmotions.add(widget.todaysEmotionLog!.emotion3!);
      }
      currentEmotion = widget.todaysEmotionLog!.emotion1;
    }
    _controllerHorizontal = ScrollController();
    for (var category in Category.values) {
      _verticalControllers[category] = ScrollController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(EmotionPickerScreen.title),
      ),
      body: Stack(children: [
        _buildEmotionWheels(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildEmotionWheels() => ListView.builder(
        controller: _controllerHorizontal,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: Category.values.length,
        itemBuilder: (context, categoryIndex) {
          final category = Category.values[categoryIndex];
          final emotions = Emotion.values.where((emotion) => emotion.category == category).toList();
          return SizedBox(
            width: 200,
            child: LoopingListView(
                controller: _verticalControllers[category],
                direction: Axis.vertical,
                children: emotions.map((emotion) {
                  return InkWell(
                    onTap: () {
                      log('Selected emotion: $emotion');
                      setState(() {
                        currentEmotion = emotion;
                      });
                      _controllerHorizontal.animateTo(
                        _controllerHorizontal.position.minScrollExtent +
                            200 * category.index.toDouble() -
                            100,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                      _verticalControllers[category]!.animateToItem(
                        emotions.indexOf(emotion),
                        itemExtent: 200,
                        itemCount: emotions.length,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: emotion.color,
                        border: currentEmotion == emotion
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$emotion',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                currentEmotion == emotion ? FontWeight.bold : FontWeight.normal,
                            color: currentEmotion == emotion ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()),
          );
        },
      );

  @override
  void dispose() {
    _controllerHorizontal.dispose();
    for (var controller in _verticalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
