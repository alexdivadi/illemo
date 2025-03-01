import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/common_widgets/looping_listview.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_upload.dart';

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

  void pushEmotion(Emotion emotion) {
    if (_selectedEmotions.length < 3) {
      setState(() {
        _selectedEmotions.add(emotion);
        currentEmotion = null;
      });
    }
  }

  void _removeEmotion(int index) {
    setState(() {
      currentEmotion = _selectedEmotions.removeAt(index);
    });
  }

  void _submitEmotions() {
    context.go(EmotionUpload.path, extra: {
      'emotionIDs': _selectedEmotions.map((e) => e.id).toList(),
      'id': widget.todaysEmotionLog?.id,
    });
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
          if (_selectedEmotions.length >= 3)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  color: Colors.black.withValues(alpha: (0.5)),
                ),
              ),
            ),
          if (_selectedEmotions.length >= 3)
            Center(
              child: ElevatedButton(
                onPressed: _submitEmotions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Submit :)', style: TextStyle(fontSize: 24, color: Colors.black)),
              ),
            ),
          Positioned(
            top: 16,
            left: 16,
            child: Row(
              children: [
                for (int index = 0; index < _selectedEmotions.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _selectedEmotions[index].color,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () => _removeEmotion(index),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ]),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (currentEmotion != null && _selectedEmotions.length < 3)
              FloatingActionButton(
                heroTag: 'addEmotion',
                backgroundColor: Colors.greenAccent,
                onPressed: () => pushEmotion(currentEmotion!),
                child: const Icon(Icons.add),
              ),
            const SizedBox(width: 16),
            if (_selectedEmotions.isNotEmpty && _selectedEmotions.length < 3)
              FloatingActionButton(
                heroTag: 'submitEmotions',
                backgroundColor: Colors.grey,
                onPressed: _submitEmotions,
                child: const Icon(Icons.arrow_forward),
              ),
          ],
        ));
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
                    onTap: _selectedEmotions.contains(emotion)
                        ? null
                        : () {
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
                        color: _selectedEmotions.contains(emotion) ? Colors.grey : emotion.color,
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
                            color: currentEmotion == emotion || _selectedEmotions.contains(emotion)
                                ? Colors.white
                                : Colors.black,
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
