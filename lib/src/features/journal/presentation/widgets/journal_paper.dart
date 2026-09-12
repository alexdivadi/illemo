import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalPaper extends StatelessWidget {
  const JournalPaper({
    super.key,
    required this.date,
    required this.child,
    this.actions = const [],
    this.minHeight = 260,
  });

  static const paperColor = Color(0xFFFAF5E4);
  static const inkColor = Color(0xFF3D2A14);
  static const mutedInkColor = Color(0xFFB09070);
  static const noteStyle = TextStyle(
    color: inkColor,
    fontFamily: 'Georgia',
    fontFamilyFallback: ['DM Serif Display', 'Times New Roman', 'serif'],
    fontSize: 17,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.68,
  );

  final DateTime date;
  final Widget child;
  final List<Widget> actions;
  final double minHeight;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: paperColor,
          border: Border.all(color: const Color(0xFFD8CBA0), width: 1.5),
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: CustomPaint(
          painter: const _RuledPaperPainter(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      DateFormat('EEEE,\nMMMM d').format(date).toUpperCase(),
                      style: const TextStyle(
                        color: mutedInkColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  ...actions,
                ]),
                const SizedBox(height: 12),
                child,
              ]),
            ),
          ),
        ),
      );
}

class _RuledPaperPainter extends CustomPainter {
  const _RuledPaperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDD0B0)
      ..strokeWidth = 1;
    for (double y = 45; y < size.height; y += 28.5) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_RuledPaperPainter oldDelegate) => false;
}
