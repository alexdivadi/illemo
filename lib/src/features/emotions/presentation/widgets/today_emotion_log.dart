import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:illemo/src/features/emotions/domain/emotion_insight.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_entry_model.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion.dart';
import 'package:illemo/src/features/emotions/presentation/screens/emotion_picker.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_glyph.dart';
import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/features/journal/presentation/widgets/today_journal.dart';
import 'package:intl/intl.dart';

class TodayEmotionLog extends StatefulWidget {
  const TodayEmotionLog({
    super.key,
    required this.entries,
    required this.journalEntry,
    required this.streakBanner,
    required this.onDelete,
    required this.onSaveJournal,
    required this.onJournalEditingChanged,
    this.footer,
  });

  final List<EmotionEntry> entries;
  final JournalEntry? journalEntry;
  final Widget streakBanner;
  final ValueChanged<String> onDelete;
  final Future<void> Function(String body) onSaveJournal;
  final ValueChanged<bool> onJournalEditingChanged;
  final Widget? footer;

  @override
  State<TodayEmotionLog> createState() => _TodayEmotionLogState();
}

class _TodayEmotionLogState extends State<TodayEmotionLog> {
  String? _expandedId;
  bool _journalEditing = false;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _stripes(context),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _journalEditing
                  ? Padding(
                      key: const ValueKey('journal-editor'),
                      padding: const EdgeInsets.all(24),
                      child: TodayJournal(
                        entry: widget.journalEntry,
                        onSave: widget.onSaveJournal,
                        initiallyEditing: true,
                        onEditingChanged: _setJournalEditing,
                      ),
                    )
                  : ListView(
                      key: const ValueKey('dashboard-content'),
                      children: [
                        if (_expandedId != null) _details(context),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(DateFormat.yMMMMEEEEd().format(DateTime.now()).toUpperCase(),
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: const Color(0xFFB18B67),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6,
                                      )),
                              const SizedBox(height: 6),
                              Text('How’s your day feeling?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.w500)),
                              const SizedBox(height: 12),
                              if (widget.entries.isEmpty)
                                _empty(context)
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _cardColor(context),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: widget.streakBanner,
                                ),
                              if (widget.entries.length >= 2) ...[
                                const SizedBox(height: 18),
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: _cardColor(context),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:
                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    const Text('🌿', style: TextStyle(fontSize: 20)),
                                    const SizedBox(width: 14),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                          Text('TODAY’S REFLECTION',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.6,
                                                  )),
                                          const SizedBox(height: 5),
                                          Text(emotionInsight(widget.entries),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Theme.of(context).colorScheme.onSurface,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.5,
                                                  )),
                                        ])),
                                  ]),
                                ),
                              ],
                              const SizedBox(height: 24),
                              TodayJournal(
                                entry: widget.journalEntry,
                                onSave: widget.onSaveJournal,
                                onEditingChanged: _setJournalEditing,
                              ),
                              if (widget.entries.length < EmotionEntry.maxPerDay)
                                FilledButton.icon(
                                    onPressed: () => context.push(EmotionPickerScreen.path),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Log a feeling')),
                            ],
                          ),
                        ),
                        if (widget.footer case final footer?) footer,
                      ],
                    ),
            ),
          ),
        ],
      );

  void _setJournalEditing(bool editing) {
    setState(() => _journalEditing = editing);
    widget.onJournalEditingChanged(editing);
  }

  Color _cardColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? Theme.of(context).colorScheme.surfaceContainerHigh
      : const Color(0xFFF0EDE6);

  Widget _stripes(BuildContext context) => SizedBox(
        height: 76,
        child: Row(children: [
          for (var index = 0; index < EmotionEntry.maxPerDay; index++)
            Expanded(
              child: _Stripe(
                entry: index < widget.entries.length ? widget.entries[index] : null,
                onTap: () {
                  if (index >= widget.entries.length) {
                    context.push(EmotionPickerScreen.path);
                  } else {
                    setState(() => _expandedId =
                        _expandedId == widget.entries[index].id ? null : widget.entries[index].id);
                  }
                },
              ),
            ),
        ]),
      );

  Widget _details(BuildContext context) {
    final entry = widget.entries.where((entry) => entry.id == _expandedId).firstOrNull;
    if (entry == null) return const SizedBox.shrink();
    final category = entry.category;
    final background = category.soft(Theme.of(context).colorScheme.surface);
    final foreground = category.foregroundOn(background);
    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: foreground)),
          Text(
              '${entry.deep == null ? '' : '${entry.specific.label} · '}${Emotion.categoryRoot(entry.category).label} · ${DateFormat.jm().format(entry.loggedAt)}',
              style: TextStyle(color: foreground.withValues(alpha: 0.68))),
        ])),
        IconButton(
            tooltip: 'Edit ${entry.label}',
            onPressed: () => context.push(
                  EmotionPickerScreen.path,
                  extra: EmotionEntryModel.fromEntity(entry).toMap(),
                ),
            icon: const Icon(Icons.edit_outlined)),
        IconButton(
            tooltip: 'Collapse ${entry.label} details',
            onPressed: () => setState(() => _expandedId = null),
            icon: const Icon(Icons.close)),
        IconButton(
            tooltip: 'Delete ${entry.label}',
            onPressed: () {
              setState(() => _expandedId = null);
              widget.onDelete(entry.id);
            },
            icon: const Icon(Icons.delete_outline)),
      ]),
    );
  }

  Widget _empty(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDD0BA), style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(22)),
        child: Column(children: [
          Text('Nothing logged yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          const Text('Tap + above or the button below to check in.', textAlign: TextAlign.center)
        ]),
      );
}

class _Stripe extends StatelessWidget {
  const _Stripe({required this.entry, required this.onTap});

  final EmotionEntry? entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final category = entry?.category;
    return Semantics(
      button: true,
      label: entry == null ? 'Add a feeling' : '${entry!.label}, tap to expand',
      child: Material(
        color: category?.cardFor(
              Theme.of(context).colorScheme.surface,
              Theme.of(context).brightness,
            ) ??
            Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: Border(
          bottom: BorderSide(color: category?.border ?? const Color(0xFFD8CBA0), width: 3),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (entry == null)
              const Icon(Icons.add, color: Color(0xFF8A7060))
            else ...[
              EmotionGlyph(emotion: category!, size: 28),
              const SizedBox(height: 2),
              Text(entry!.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: category.foregroundOn(
                      category.cardFor(
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).brightness,
                      ),
                    ),
                  )),
            ],
          ]),
        ),
      ),
    );
  }
}
