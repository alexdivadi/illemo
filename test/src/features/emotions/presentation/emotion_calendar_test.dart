import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/calendar_day.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_calendar.dart';
import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/features/journal/presentation/widgets/journal_paper.dart';

void main() {
  testWidgets('three emotions require a journal entry for calendar completion', (tester) async {
    final date = DateTime(2026, 8, 18);
    final emotions = [
      EmotionEntry(id: '1', emotionId: 'joy.hopeful', loggedAt: date),
      EmotionEntry(id: '2', emotionId: 'sadness.lonely', loggedAt: date),
      EmotionEntry(id: '3', emotionId: 'fear.anxious', loggedAt: date),
    ];

    Future<void> pump(List<JournalEntry> journals) => tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: CalendarWidget(
              emotionEntries: emotions,
              journalEntries: journals,
              currentDate: date,
            ),
          ),
        ));
    CalendarDay targetDay() => tester
        .widgetList<CalendarDay>(find.byType(CalendarDay))
        .singleWhere((day) => day.date.day == date.day);

    await pump(const []);
    expect(targetDay().isComplete, isFalse);

    await pump([
      JournalEntry(id: 'note', body: 'Today', date: date, updatedAt: date),
    ]);
    expect(targetDay().isComplete, isTrue);

    await tester.tap(find.byWidgetPredicate(
      (widget) => widget is CalendarDay && widget.date.day == date.day,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(JournalPaper), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    final labels =
        ['Hopeful', 'Lonely', 'Anxious'].map((label) => tester.getCenter(find.text(label)));
    expect(labels.map((center) => center.dy).toSet(), hasLength(1));
  });
}
