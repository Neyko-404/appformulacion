import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focusly/features/companion/presentation/companion_cat_palette.dart';
import 'package:focusly/features/companion/presentation/models/cat_pose.dart';

final class CatPainter extends CustomPainter {
  const CatPainter({
    required this.pose,
    required this.palette,
    this.breath = 0,
    this.blink = 0,
    this.tail = 0,
    this.celebration = 0,
  });

  final CatPose pose;
  final CompanionCatPalette palette;
  final double breath;
  final double blink;
  final double tail;
  final double celebration;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 100;
    canvas
      ..save()
      ..scale(scale, scale)
      ..translate((size.width / scale - 100) / 2, 0)
      ..translate(0, pose.verticalOffset * 100 - celebration * 8);
    final outline = Paint()
      ..color = palette.outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final fur = Paint()..color = palette.furColor;
    final accent = Paint()..color = palette.accentColor;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 91), width: 58, height: 7),
      Paint()..color = palette.shadowColor,
    );
    canvas.save();
    canvas.translate(74, 68);
    canvas.rotate(pose.tailAngle + tail);
    canvas.drawArc(
      const Rect.fromLTWH(-1, -22, 25, 38),
      -.8,
      2.2,
      false,
      outline..strokeWidth = 7,
    );
    canvas.restore();
    final bodyHeight = 39 * pose.bodyScale * (1 + breath);
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: const Offset(50, 69),
        width: 45,
        height: bodyHeight,
      ),
      const Radius.circular(22),
    );
    canvas.drawRRect(body, fur);
    canvas.drawRRect(body, outline..strokeWidth = 2);
    canvas.drawOval(const Rect.fromLTWH(31, 79, 12, 15), fur);
    canvas.drawOval(Rect.fromLTWH(57, 79 - pose.pawLift * 25, 12, 15), fur);
    canvas.save();
    canvas.translate(50, 37);
    canvas.rotate(pose.headTilt);
    final leftEar = Path()
      ..moveTo(-25, -12)
      ..lineTo(-18, -34 + pose.earTilt * 20)
      ..lineTo(-6, -17)
      ..close();
    final rightEar = Path()
      ..moveTo(25, -12)
      ..lineTo(18, -34 - pose.earTilt * 20)
      ..lineTo(6, -17)
      ..close();
    canvas.drawPath(leftEar, fur);
    canvas.drawPath(rightEar, fur);
    canvas.drawPath(leftEar, outline);
    canvas.drawPath(rightEar, outline);
    canvas.drawCircle(Offset.zero, 27, fur);
    canvas.drawCircle(Offset.zero, 27, outline);
    final eyeHeight = 5 * pose.eyeOpenness * (1 - blink).clamp(0, 1);
    final eyePaint = Paint()..color = palette.eyeColor;
    for (final x in [-10.0, 10.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, -4),
          width: 4,
          height: math.max(1, eyeHeight),
        ),
        eyePaint,
      );
    }
    canvas.drawCircle(const Offset(0, 4), 2.2, accent);
    _paintMouth(canvas, outline);
    canvas.restore();
    canvas.restore();
  }

  void _paintMouth(Canvas canvas, Paint paint) {
    switch (pose.mouthStyle) {
      case CatMouthStyle.neutral:
      case CatMouthStyle.focused:
        canvas.drawLine(const Offset(-4, 10), const Offset(4, 10), paint);
      case CatMouthStyle.smile:
      case CatMouthStyle.cheering:
        canvas.drawArc(
          const Rect.fromLTWH(-7, 5, 14, 10),
          0,
          math.pi,
          false,
          paint,
        );
      case CatMouthStyle.relaxed:
        canvas.drawArc(
          const Rect.fromLTWH(-5, 7, 10, 5),
          0,
          math.pi,
          false,
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant CatPainter oldDelegate) =>
      oldDelegate.pose != pose ||
      oldDelegate.palette != palette ||
      oldDelegate.breath != breath ||
      oldDelegate.blink != blink ||
      oldDelegate.tail != tail ||
      oldDelegate.celebration != celebration;
}
