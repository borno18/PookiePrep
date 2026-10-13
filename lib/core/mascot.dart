import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

enum MascotPose {
  greeting,
  thinking,
  cheering,
  sleepy,
  encourage,
}

/// A delightful, vector-drawn white puppy mascot ("Pookie") with 5 expressive poses.
class PookieMascot extends StatelessWidget {
  const PookieMascot({
    super.key,
    this.pose = MascotPose.greeting,
    this.size = 100,
    this.speechBubble,
  });

  final MascotPose pose;
  final double size;
  final String? speechBubble;

  @override
  Widget build(BuildContext context) {
    final mascotWidget = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PuppyPainter(pose: pose),
      ),
    );

    if (speechBubble == null) {
      return mascotWidget;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: PookieColors.primaryDeep.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: PookieColors.blush, width: 1.5),
          ),
          child: Text(
            speechBubble!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PookieColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
        mascotWidget,
      ],
    );
  }
}

class _PuppyPainter extends CustomPainter {
  _PuppyPainter({required this.pose});

  final MascotPose pose;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final scale = math.min(w, h) / 100;

    canvas.save();
    canvas.translate((w - 100 * scale) / 2, (h - 100 * scale) / 2);
    canvas.scale(scale, scale);

    final whitePaint = Paint()..color = const Color(0xFFFCFCFC);
    final shadowPaint = Paint()..color = const Color(0xFFF0E5EB);
    final earInnerPaint = Paint()..color = const Color(0xFFFFD1DF);
    final blushPaint = Paint()
      ..color = const Color(0xFFFFB6CE).withOpacity(0.55);
    final inkPaint = Paint()..color = PookieColors.ink;
    final eyePaint = Paint()..color = const Color(0xFF2C1820);
    final whiteDot = Paint()..color = Colors.white;
    final collarPaint = Paint()..color = PookieColors.primaryDeep;
    final bellPaint = Paint()..color = const Color(0xFFFFD54F);

    // Subtle drop shadow under puppy
    canvas.drawOval(
      const Rect.fromLTWH(18, 88, 64, 10),
      Paint()..color = PookieColors.primary.withOpacity(0.2),
    );

    // Body
    final bodyPath = Path()
      ..moveTo(30, 68)
      ..cubicTo(26, 85, 30, 92, 42, 92)
      ..lineTo(58, 92)
      ..cubicTo(70, 92, 74, 85, 70, 68)
      ..close();
    canvas.drawPath(bodyPath, shadowPaint);
    canvas.drawPath(bodyPath, whitePaint);

    // Collar
    final collarPath = Path()
      ..moveTo(32, 66)
      ..quadraticBezierTo(50, 72, 68, 66)
      ..lineTo(67, 71)
      ..quadraticBezierTo(50, 77, 33, 71)
      ..close();
    canvas.drawPath(collarPath, collarPaint);

    // Bell or Heart Pendant
    canvas.drawCircle(const Offset(50, 75), 3.5, bellPaint);

    // Front Paws based on pose
    if (pose == MascotPose.cheering) {
      // Paws raised high
      canvas.drawCircle(const Offset(24, 38), 6, whitePaint);
      canvas.drawCircle(const Offset(76, 38), 6, whitePaint);
      // Small sparkle stars
      _drawSparkle(canvas, 16, 22, PookieColors.primaryDeep);
      _drawSparkle(canvas, 84, 22, PookieColors.accent);
    } else if (pose == MascotPose.greeting) {
      // Left paw down, Right paw waving
      canvas.drawCircle(const Offset(38, 86), 6, whitePaint);
      canvas.drawCircle(const Offset(76, 54), 6, whitePaint);
      // Tiny flower in greeting
      _drawFlower(canvas, 85, 50);
    } else if (pose == MascotPose.thinking) {
      // One paw at chin
      canvas.drawCircle(const Offset(36, 86), 6, whitePaint);
      canvas.drawCircle(const Offset(58, 64), 6, whitePaint);
      // Question mark floating
      _drawText(canvas, '?', 80, 24, 18, PookieColors.primaryDeep);
    } else if (pose == MascotPose.encourage) {
      // Paw outstretched forward
      canvas.drawCircle(const Offset(36, 86), 6, whitePaint);
      canvas.drawCircle(const Offset(72, 72), 7, whitePaint);
      // Tiny heart floating
      _drawHeart(canvas, 82, 58, 7);
    } else {
      // Regular paws resting
      canvas.drawCircle(const Offset(38, 87), 6, whitePaint);
      canvas.drawCircle(const Offset(62, 87), 6, whitePaint);
    }

    // Head transform (tilt if thinking)
    canvas.save();
    if (pose == MascotPose.thinking) {
      canvas.translate(50, 42);
      canvas.rotate(0.12);
      canvas.translate(-50, -42);
    }

    // Left Ear
    final leftEar = Path()
      ..moveTo(26, 26)
      ..cubicTo(12, 34, 14, 58, 24, 60)
      ..cubicTo(29, 60, 32, 45, 34, 32)
      ..close();
    canvas.drawPath(leftEar, whitePaint);
    final leftEarInner = Path()
      ..moveTo(24, 32)
      ..cubicTo(16, 38, 17, 52, 23, 54)
      ..cubicTo(26, 54, 28, 44, 28, 36)
      ..close();
    canvas.drawPath(leftEarInner, earInnerPaint);

    // Right Ear
    final rightEar = Path()
      ..moveTo(74, 26)
      ..cubicTo(88, 34, 86, 58, 76, 60)
      ..cubicTo(71, 60, 68, 45, 66, 32)
      ..close();
    canvas.drawPath(rightEar, whitePaint);
    final rightEarInner = Path()
      ..moveTo(76, 32)
      ..cubicTo(84, 38, 83, 52, 77, 54)
      ..cubicTo(74, 54, 72, 44, 72, 36)
      ..close();
    canvas.drawPath(rightEarInner, earInnerPaint);

    // Head Base
    final headRect = const Rect.fromLTWH(22, 16, 56, 52);
    canvas.drawOval(headRect, shadowPaint);
    canvas.drawOval(headRect, whitePaint);

    // Cheeks Blush
    canvas.drawOval(const Rect.fromLTWH(28, 44, 11, 7), blushPaint);
    canvas.drawOval(const Rect.fromLTWH(61, 44, 11, 7), blushPaint);

    // Eyes
    if (pose == MascotPose.sleepy) {
      // Curved sleeping eyes
      final sleepLeft = Path()
        ..moveTo(34, 40)
        ..quadraticBezierTo(39, 44, 44, 40);
      final sleepRight = Path()
        ..moveTo(56, 40)
        ..quadraticBezierTo(61, 44, 66, 40);
      final linePaint = Paint()
        ..color = eyePaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(sleepLeft, linePaint);
      canvas.drawPath(sleepRight, linePaint);
      // Floating Zzz
      _drawText(canvas, 'z', 76, 16, 12, PookieColors.accent);
      _drawText(canvas, 'Z', 84, 8, 16, PookieColors.primaryDeep);
    } else {
      // Big shiny expressive puppy eyes
      canvas.drawCircle(const Offset(39, 39), 4.5, eyePaint);
      canvas.drawCircle(const Offset(61, 39), 4.5, eyePaint);

      // Catchlights
      canvas.drawCircle(const Offset(37.5, 37.5), 1.6, whiteDot);
      canvas.drawCircle(const Offset(40.5, 40.5), 0.8, whiteDot);
      canvas.drawCircle(const Offset(59.5, 37.5), 1.6, whiteDot);
      canvas.drawCircle(const Offset(62.5, 40.5), 0.8, whiteDot);
    }

    // Tiny Nose
    final nosePath = Path()
      ..moveTo(47.5, 46)
      ..lineTo(52.5, 46)
      ..quadraticBezierTo(50, 49.5, 47.5, 46)
      ..close();
    canvas.drawPath(nosePath, inkPaint);

    // Cute W-smile mouth
    final mouthPaint = Paint()
      ..color = inkPaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final mouthLeft = Path()
      ..moveTo(46, 50)
      ..quadraticBezierTo(48, 53, 50, 49);
    final mouthRight = Path()
      ..moveTo(50, 49)
      ..quadraticBezierTo(52, 53, 54, 50);

    canvas.drawPath(mouthLeft, mouthPaint);
    canvas.drawPath(mouthRight, mouthPaint);

    canvas.restore();
    canvas.restore();
  }

  void _drawSparkle(Canvas canvas, double x, double y, Color color) {
    final p = Paint()..color = color;
    final path = Path()
      ..moveTo(x, y - 5)
      ..quadraticBezierTo(x, y, x + 5, y)
      ..quadraticBezierTo(x, y, x, y + 5)
      ..quadraticBezierTo(x, y, x - 5, y)
      ..quadraticBezierTo(x, y, x, y - 5)
      ..close();
    canvas.drawPath(path, p);
  }

  void _drawFlower(Canvas canvas, double x, double y) {
    final petalPaint = Paint()..color = const Color(0xFFFFB6CE);
    final centerPaint = Paint()..color = const Color(0xFFFFD54F);
    for (int i = 0; i < 5; i++) {
      final angle = i * (2 * math.pi / 5);
      final px = x + 3.5 * math.cos(angle);
      final py = y + 3.5 * math.sin(angle);
      canvas.drawCircle(Offset(px, py), 2.2, petalPaint);
    }
    canvas.drawCircle(Offset(x, y), 2, centerPaint);
  }

  void _drawHeart(Canvas canvas, double x, double y, double size) {
    final paint = Paint()..color = PookieColors.primaryDeep;
    final path = Path();
    path.moveTo(x, y);
    path.cubicTo(
        x - size, y - size, x - size * 1.4, y + size * 0.4, x, y + size * 1.2);
    path.cubicTo(x + size * 1.4, y + size * 0.4, x + size, y - size, x, y);
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, double x, double y,
      double fontSize, Color color) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant _PuppyPainter oldDelegate) =>
      oldDelegate.pose != pose;
}
