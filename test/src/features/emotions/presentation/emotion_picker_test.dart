import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/data/providers/daily_reflection.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_log.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_upload.dart';

void main() {
  Future<void> pumpPicker(
    WidgetTester tester, {
    EmotionLog? log,
    void Function(Map<String, dynamic>)? onSubmit,
    bool remoteConfigFails = false,
  }) async {
    final router = GoRouter(
      initialLocation: EmotionPickerScreen.path,
      routes: [
        GoRoute(
          path: EmotionPickerScreen.path,
          builder: (_, __) => EmotionPickerScreen(todaysEmotionLog: log),
        ),
        GoRoute(
          path: EmotionUpload.path,
          builder: (_, state) {
            onSubmit?.call(state.extra! as Map<String, dynamic>);
            return const Scaffold(body: Text('Uploading'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dailyReflectionProvider.overrideWith(
            (ref) => remoteConfigFails
                ? Future<String>.error(Exception('offline'))
                : Future.value('What is present for you right now?'),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows six categories in two columns and progresses through tiers', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpPicker(tester);

    expect(find.byKey(const Key('category-grid')), findsOneWidget);
    for (final category in Category.values) {
      expect(find.byKey(Key('category-${category.name}')), findsOneWidget);
    }
    final cards = Category.values
        .map((category) => tester.getCenter(find.byKey(Key('category-${category.name}'))))
        .toList();
    expect(cards.map((point) => point.dx).toSet().length, 2);
    expect(cards.map((point) => point.dy).toSet().length, 3);

    await tester.tap(find.byKey(const Key('category-joyful')));
    await tester.pump();
    expect(find.byKey(const Key('emotion-tier-2')), findsOneWidget);
    expect(find.byKey(const Key('selected-joyful')), findsNothing);

    await tester.tap(find.byTooltip('Back to categories'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('category-joyful')));
    await tester.pump();
    expect(find.byKey(const Key('selected-joyful')), findsNothing);

    await tester.tap(find.byKey(const Key('emotion-hopeful')));
    await tester.pump();
    expect(find.byKey(const Key('emotion-tier-3')), findsOneWidget);
    expect(find.byKey(const Key('selected-hopeful')), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('save-tier-2')));
    await tester.tap(find.byKey(const Key('save-tier-2')));
    await tester.pump();
    expect(find.byKey(const Key('selected-hopeful')), findsOneWidget);

    await tester.tap(find.byTooltip('Remove Hopeful'));
    await tester.pump();
    expect(find.byKey(const Key('selected-hopeful')), findsNothing);
  });

  testWidgets('preserves an existing log and submits its IDs and document ID', (tester) async {
    Map<String, dynamic>? payload;
    final log = EmotionLog(
      id: 'today-id',
      emotion1: Emotion.sad,
      emotion2: Emotion.peaceful,
      date: DateTime(2026, 8, 16),
    );
    await pumpPicker(tester, log: log, onSubmit: (value) => payload = value);

    expect(find.byKey(const Key('selected-sad')), findsOneWidget);
    expect(find.byKey(const Key('selected-peaceful')), findsOneWidget);
    await tester.tap(find.byKey(const Key('submit-emotions')));
    await tester.pumpAndSettle();

    expect(payload?['emotionIDs'], [Emotion.sad.id, Emotion.peaceful.id]);
    expect(payload?['id'], 'today-id');
  });

  testWidgets('submits one emotion before the log is complete', (tester) async {
    Map<String, dynamic>? payload;
    await pumpPicker(tester, onSubmit: (value) => payload = value);
    await tester.tap(find.byKey(const Key('category-sad')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('emotion-guilty')));
    await tester.pump();
    expect(find.byKey(const Key('selected-guilty')), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('save-tier-2')));
    await tester.tap(find.byKey(const Key('save-tier-2')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('submit-emotions')));
    await tester.pumpAndSettle();
    expect(payload?['emotionIDs'], [Emotion.guilty.id]);
  });

  testWidgets('submits three unique IDs and shows completion', (tester) async {
    Map<String, dynamic>? payload;
    await pumpPicker(tester, onSubmit: (value) => payload = value);
    await tester.tap(find.byKey(const Key('category-sad')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('emotion-guilty')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('emotion-remorseful')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('category-sad')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('emotion-guilty')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('save-tier-2')));
    await tester.tap(find.byKey(const Key('save-tier-2')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('category-peaceful')));
    await tester.tap(find.byKey(const Key('category-peaceful')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('emotion-content')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('emotion-relaxed')));
    await tester.pump();

    expect(find.text('Today’s log is complete'), findsOneWidget);
    await tester.tap(find.byKey(const Key('submit-emotions')));
    await tester.pumpAndSettle();
    expect(payload?['emotionIDs'], [8, 2, 21]);
  });

  testWidgets('shows the Remote Config default when fetching fails', (tester) async {
    await pumpPicker(tester, remoteConfigFails: true);
    await tester.pump();
    expect(find.text(dailyReflectionDefault), findsOneWidget);
  });
}
