import 'package:flutter/material.dart';
import 'package:illemo/src/features/journal/domain/entities/journal_entry.dart';
import 'package:illemo/src/features/journal/presentation/widgets/journal_paper.dart';

class TodayJournal extends StatefulWidget {
  const TodayJournal({
    super.key,
    required this.entry,
    required this.onSave,
    this.initiallyEditing = false,
    this.onEditingChanged,
  });

  final JournalEntry? entry;
  final Future<void> Function(String body) onSave;
  final bool initiallyEditing;
  final ValueChanged<bool>? onEditingChanged;

  @override
  State<TodayJournal> createState() => _TodayJournalState();
}

class _TodayJournalState extends State<TodayJournal> {
  late final TextEditingController _controller;
  late bool _editing;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _editing = widget.initiallyEditing;
    _controller = TextEditingController(text: widget.entry?.body);
  }

  @override
  void didUpdateWidget(TodayJournal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing && oldWidget.entry?.body != widget.entry?.body) {
      _controller.text = widget.entry?.body ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _edit() => setState(() {
        _controller.text = widget.entry?.body ?? '';
        _editing = true;
        widget.onEditingChanged?.call(true);
      });

  void _cancel() => setState(() {
        _controller.text = widget.entry?.body ?? '';
        _editing = false;
        widget.onEditingChanged?.call(false);
      });

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave(_controller.text);
      if (mounted) {
        setState(() => _saving = _editing = false);
        widget.onEditingChanged?.call(false);
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_editing && widget.entry == null) {
      return OutlinedButton.icon(
        onPressed: _edit,
        icon: const Icon(Icons.edit_note),
        label: const Align(
          alignment: Alignment.centerLeft,
          child:
              Text('Write a note about your day…', style: TextStyle(fontStyle: FontStyle.italic)),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          side: const BorderSide(color: Color(0xFFD0C4A8), style: BorderStyle.solid),
        ),
      );
    }

    return JournalPaper(
      date: DateTime.now(),
      actions: _editing
          ? [
              IconButton.filledTonal(
                tooltip: 'Cancel editing',
                onPressed: _saving ? null : _cancel,
                color: JournalPaper.mutedInkColor,
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                tooltip: 'Save note',
                onPressed: _saving ? null : _save,
                style: IconButton.styleFrom(
                  backgroundColor: JournalPaper.inkColor,
                  foregroundColor: JournalPaper.paperColor,
                ),
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
              ),
            ]
          : [
              IconButton.filledTonal(
                tooltip: 'Edit note',
                onPressed: _edit,
                color: JournalPaper.mutedInkColor,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
      child: _editing
          ? Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                minLines: null,
                maxLines: null,
                expands: true,
                cursorColor: const Color(0xFF8A6040),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: 'What’s on your mind today…',
                  hintStyle: TextStyle(color: Color(0xFFC0A880)),
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: JournalPaper.noteStyle,
              ),
            )
          : Text(widget.entry!.body, style: JournalPaper.noteStyle),
    );
  }
}
