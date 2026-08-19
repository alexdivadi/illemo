import 'package:flutter/material.dart';
import 'package:illemo/src/utils/capitalize.dart';

enum Category implements Comparable<Category> {
  sad(1, baseColor: Colors.blue, softColor: Color(0xFFDDEBFA)),
  mad(2, baseColor: Colors.deepOrange, softColor: Color(0xFFFFDED6)),
  scared(3, baseColor: Colors.purple, softColor: Color(0xFFE9E0F5)),
  joyful(4, baseColor: Colors.amber, softColor: Color(0xFFFFF0B8)),
  peaceful(5, baseColor: Colors.green, softColor: Color(0xFFDDEEDF)),
  powerful(6, baseColor: Colors.orange, softColor: Color(0xFFFFE3BE)),
  ;

  const Category(this.id, {required this.baseColor, required this.softColor});

  final int id;
  final MaterialColor baseColor;
  final Color softColor;

  /// Run a calculation to get the shaded color associated with the emotion's category.
  /// The tier determines how dark the color is, with tier 1 being the darkest.
  Color getColor(int tier) => baseColor[900 - tier * 200]!;

  @override
  int compareTo(Category other) => id - other.id;

  static final Map<int, Category> _categoryById = {
    for (var category in Category.values) category.id: category
  };

  /// Returns the [Category] associated with the given [id].
  ///
  /// Throws an [ArgumentError] if no category with the given [id] is found.
  static Category get(int id) {
    return _categoryById[id] ?? (throw ArgumentError('Emotion with id $id not found'));
  }

  @override
  String toString() {
    return name.capitalize();
  }
}

extension CategoryEmotionPresentation on Category {
  Color get card => softColor;
  Color get border => baseColor.shade300;
  Color get foreground => baseColor.shade900;

  Color cardFor(Color surface, Brightness brightness) => brightness == Brightness.dark
      ? Color.alphaBlend(border.withValues(alpha: 0.18), surface)
      : card;

  Color soft(Color surface) => Color.alphaBlend(border.withValues(alpha: 0.20), surface);
  Color flood(Color surface) => Color.alphaBlend(border.withValues(alpha: 0.42), surface);
  Color foregroundOn(Color surface) =>
      ThemeData.estimateBrightnessForColor(surface) == Brightness.dark
          ? Color.alphaBlend(border.withValues(alpha: 0.35), Colors.white)
          : foreground;
}
