import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:illemo/src/features/emotions/domain/models/emotion_definition.dart';

class EmotionGlyph extends StatelessWidget {
  const EmotionGlyph({super.key, required this.emotion, this.size = 48});

  final EmotionKey emotion;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
        child: CustomPaint(
          size: Size.square(size),
          painter: _EmotionGlyphPainter(emotion, emotion.border),
        ),
      );
}

class _EmotionGlyphPainter extends CustomPainter {
  const _EmotionGlyphPainter(this.emotion, this.color);

  final EmotionKey emotion;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final scale = size.width / 56;
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    switch (emotion) {
      case EmotionKey.joy:
        canvas.drawCircle(center, 9 * scale, paint);
        line.strokeWidth = 2.5 * scale;
        for (var degrees = 0; degrees < 360; degrees += 45) {
          final angle = degrees * math.pi / 180;
          final direction = Offset(math.cos(angle), math.sin(angle));
          canvas.drawLine(center + direction * 14 * scale, center + direction * 21 * scale, line);
        }
      case EmotionKey.sadness:
        final path = Path()
          ..moveTo(28 * scale, 5 * scale)
          ..cubicTo(28 * scale, 5 * scale, 10 * scale, 18 * scale, 10 * scale, 31 * scale)
          ..cubicTo(10 * scale, 41 * scale, 18 * scale, 49 * scale, 28 * scale, 49 * scale)
          ..cubicTo(38 * scale, 49 * scale, 46 * scale, 41 * scale, 46 * scale, 31 * scale)
          ..cubicTo(46 * scale, 18 * scale, 28 * scale, 5 * scale, 28 * scale, 5 * scale)
          ..close();
        canvas.drawPath(path, paint..color = color.withValues(alpha: 0.82));
      case EmotionKey.anger:
        canvas.drawPath(
          Path()
            ..moveTo(32 * scale, 5 * scale)
            ..lineTo(21 * scale, 24 * scale)
            ..lineTo(30 * scale, 24 * scale)
            ..lineTo(17 * scale, 51 * scale)
            ..lineTo(40 * scale, 27 * scale)
            ..lineTo(30 * scale, 27 * scale)
            ..lineTo(43 * scale, 5 * scale)
            ..close(),
          paint,
        );
      case EmotionKey.fear:
        line.strokeWidth = 5 * scale;
        canvas.drawArc(
            Rect.fromCircle(center: center, radius: 21 * scale), math.pi / 2, math.pi, false, line);
        canvas.drawCircle(center, 6 * scale, Paint()..color = color.withValues(alpha: 0.45));
      case EmotionKey.disgust:
        line.strokeWidth = 4.5 * scale;
        final path = Path()..moveTo(4 * scale, 28 * scale);
        for (var x = 4.0; x < 52; x += 8) {
          path.quadraticBezierTo((x + 4) * scale, (x ~/ 8).isEven ? 20 * scale : 36 * scale,
              (x + 8) * scale, 28 * scale);
        }
        canvas.drawPath(path, line);
      case EmotionKey.surprise:
        for (var degrees = 0; degrees < 360; degrees += 30) {
          final angle = degrees * math.pi / 180;
          final direction = Offset(math.cos(angle), math.sin(angle));
          final long = degrees % 60 == 0;
          line.strokeWidth = (long ? 3.5 : 2) * scale;
          canvas.drawLine(center + direction * (long ? 5 : 10) * scale,
              center + direction * (long ? 23 : 17) * scale, line);
        }
        canvas.drawCircle(center, 4.5 * scale, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_EmotionGlyphPainter oldDelegate) =>
      oldDelegate.emotion != emotion || oldDelegate.color != color;
}
