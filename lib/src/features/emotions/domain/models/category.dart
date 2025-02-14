import 'package:flutter/material.dart';
import 'package:illemo/src/utils/capitalize.dart';

enum Category implements Comparable<Category> {
  sad(1, baseColor: Colors.blue),
  mad(2, baseColor: Colors.deepOrange),
  scared(3, baseColor: Colors.purple),
  joyful(4, baseColor: Colors.pink),
  peaceful(5, baseColor: Colors.green),
  powerful(6, baseColor: Colors.amber),
  ;

  const Category(this.id, {required this.baseColor});

  final int id;
  final MaterialColor baseColor;

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
