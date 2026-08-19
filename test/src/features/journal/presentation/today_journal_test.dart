import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/features/journal/presentation/widgets/today_journal.dart';

void main() {
  testWidgets('uses pencil to edit, close to cancel, and has no delete button', (tester) async {
    final entry = JournalEntry(
      id: 'journal',
      body: 'A note',
      date: DateTime(2026, 8, 18),
      updatedAt: DateTime(2026, 8, 18),
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: TodayJournal(entry: entry, onSave: (_) async {})),
    ));

    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.textContaining('Delete'), findsNothing);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
