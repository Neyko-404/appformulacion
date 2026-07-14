import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:focusly/features/companion/presentation/companion_cat_palette.dart';
import 'package:focusly/features/companion/presentation/models/cat_pose.dart';

final class StudyCatPainter extends CustomPainter {
  const StudyCatPainter({
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
    if (!size.isFinite || size.isEmpty) return;
    const designExtent = 112.0;
    final scale = math.min(
      size.width / designExtent,
      size.height / designExtent,
    );
    final horizontalInset = (size.width - designExtent * scale) / 2;
    final verticalInset = (size.height - designExtent * scale) / 2;
    canvas
      ..save()
      ..translate(horizontalInset, verticalInset)
      ..scale(scale, scale)
      ..translate(6, 9)
      ..translate(0, pose.verticalOffset * 100 - celebration * 100);
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
    const tailRect = Rect.fromLTWH(-1, -22, 25, 38);
    canvas.drawArc(tailRect, -.8, 2.2, false, outline..strokeWidth = 9);
    canvas.drawArc(
      tailRect,
      -.8,
      2.2,
      false,
      Paint()
        ..color = palette.furColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
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
    final innerEar = Paint()..color = palette.innerEarColor;
    canvas.drawPath(
      Path()
        ..moveTo(-20, -15)
        ..lineTo(-17, -27 + pose.earTilt * 12)
        ..lineTo(-10, -17)
        ..close(),
      innerEar,
    );
    canvas.drawPath(
      Path()
        ..moveTo(20, -15)
        ..lineTo(17, -27 - pose.earTilt * 12)
        ..lineTo(10, -17)
        ..close(),
      innerEar,
    );
    canvas.drawCircle(Offset.zero, 27, fur);
    canvas.drawCircle(Offset.zero, 27, outline);
    _paintAccent(canvas, accent);
    final eyeHeight = 5 * pose.eyeOpenness * (1 - blink).clamp(0, 1);
    final eyePaint = Paint()..color = palette.eyeColor;
    for (final x in [-10.0, 10.0]) {
      if (eyeHeight <= .5) {
        canvas.drawLine(Offset(x - 3, -4), Offset(x + 3, -4), outline);
      } else if (pose.mouthStyle == CatMouthStyle.smile ||
          pose.mouthStyle == CatMouthStyle.cheering) {
        canvas.drawArc(
          Rect.fromCenter(center: Offset(x, -2), width: 8, height: 6),
          math.pi,
          math.pi,
          false,
          outline,
        );
      } else {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x, -4),
            width: 4,
            height: math.max(1, eyeHeight),
          ),
          eyePaint,
        );
      }
    }
    canvas.drawCircle(const Offset(0, 4), 2.2, accent);
    canvas.drawCircle(
      const Offset(-10, -12),
      2,
      Paint()..color = palette.highlightColor,
    );
    _paintMouth(canvas, outline);
    canvas.restore();
    canvas.restore();
  }

  void _paintAccent(Canvas canvas, Paint paint) {
    switch (pose.accentStyle) {
      case CatAccentStyle.forehead:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-3, -25, 6, 9),
            const Radius.circular(3),
          ),
          paint,
        );
      case CatAccentStyle.ears:
        canvas.drawCircle(const Offset(-17, -18), 3, paint);
        canvas.drawCircle(const Offset(17, -18), 3, paint);
      case CatAccentStyle.mask:
        canvas.drawOval(const Rect.fromLTWH(-17, -10, 13, 10), paint);
        canvas.drawOval(const Rect.fromLTWH(4, -10, 13, 10), paint);
      case CatAccentStyle.cheeks:
        canvas.drawCircle(const Offset(-17, 5), 2.5, paint);
        canvas.drawCircle(const Offset(17, 5), 2.5, paint);
      case CatAccentStyle.chest:
        canvas.drawArc(
          const Rect.fromLTWH(-9, 17, 18, 12),
          0,
          math.pi,
          false,
          Paint()
            ..color = paint.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
    }
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
  bool shouldRepaint(covariant StudyCatPainter oldDelegate) =>
      oldDelegate.pose != pose ||
      oldDelegate.palette != palette ||
      oldDelegate.breath != breath ||
      oldDelegate.blink != blink ||
      oldDelegate.tail != tail ||
      oldDelegate.celebration != celebration;
}
