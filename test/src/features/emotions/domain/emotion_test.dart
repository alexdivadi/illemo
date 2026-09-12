import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';

void main() {
  test('includes the added emotions in their picker branches', () {
    expect(Emotion.specificsFor(Category.joyful), contains(Emotion.joyPowerful));
    expect(Emotion.specificsFor(Category.sad), contains(Emotion.sadnessBored));
    expect(
      Emotion.childrenOf(Emotion.sadnessBored.id),
      containsAll([Emotion.sadnessBoredApathetic, Emotion.sadnessBoredIndifferent]),
    );
    expect(
      Emotion.childrenOf(Emotion.sadnessTired.id),
      containsAll([
        Emotion.sadnessTiredExhausted,
        Emotion.sadnessTiredDrained,
        Emotion.sadnessTiredDepleted,
        Emotion.sadnessTiredSpent,
      ]),
    );
    expect(
      Emotion.childrenOf(Emotion.sadnessGuilty.id),
      containsAll([
        Emotion.sadnessGuiltyRegretful,
        Emotion.sadnessGuiltyAshamed,
        Emotion.sadnessGuiltyRemorseful,
      ]),
    );
  });
}
