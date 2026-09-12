import 'package:flutter/material.dart';
import 'package:illemo/src/features/emotions/domain/entities/emotion_entry.dart';
import 'package:illemo/src/features/emotions/domain/models/category.dart';
import 'package:illemo/src/features/emotions/presentation/widgets/emotion_glyph.dart';

class LoggedEmotionIcons extends StatelessWidget {
  const LoggedEmotionIcons({super.key, required this.entries});

  final List<EmotionEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(children: [
        Text('TODAY', style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(width: 10),
        for (final entry in entries) ...[
          Tooltip(
            message: entry.label,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entry.category.cardFor(
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).brightness,
                ),
                border: Border.all(color: entry.category.border, width: 2),
              ),
              alignment: Alignment.center,
              child: EmotionGlyph(emotion: entry.category, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ]),
    );
  }
}
