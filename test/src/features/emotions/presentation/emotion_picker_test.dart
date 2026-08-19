import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/data/repositories/emotion_repository.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';

void main() {
  testWidgets('progresses through the emotion tiers', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: EmotionPickerScreen.path,
      routes: [
        GoRoute(
          path: EmotionPickerScreen.path,
          builder: (_, __) => const EmotionPickerScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          emotionEntriesTodayProvider.overrideWith(
            (ref) => Stream.value(const <EmotionEntry>[]),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();

    expect(find.text('What are you feeling right now?'), findsOneWidget);
    await tester.tap(find.text('Joy'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('More specifically…'), findsOneWidget);

    await tester.tap(find.text('Hopeful'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Even more precisely?'), findsOneWidget);
    expect(find.text('Optimistic'), findsOneWidget);
  });
}
