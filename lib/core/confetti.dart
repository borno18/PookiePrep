import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

class PookieConfetti extends StatefulWidget {
  const PookieConfetti({super.key, required this.child});

  final Widget child;

  @override
  State<PookieConfetti> createState() => _PookieConfettiState();
}

class _PookieConfettiState extends State<PookieConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..addListener(() => setState(() {}));

    const colors = [
      PookieColors.primary,
      PookieColors.primaryDeep,
      PookieColors.accent,
      PookieColors.ok,
      Color(0xFFFFD54F),
      Color(0xFFFF8A80),
    ];

    for (int i = 0; i < 45; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: -_random.nextDouble() * 0.4,
          speed: 0.4 + _random.nextDouble() * 0.7,
          size: 6 + _random.nextDouble() * 8,
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 8,
          color: colors[_random.nextInt(colors.length)],
          isHeart: i % 4 == 0,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 1;
    } else if (_controller.value == 0 && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!MediaQuery.disableAnimationsOf(context))
          IgnorePointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(
                particles: _particles,
                progress: _controller.value,
              ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.isHeart,
  });

  final double x;
  final double y;
  final double speed;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final bool isHeart;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final currentY = (p.y + p.speed * progress) * size.height;
      final currentX =
          (p.x + math.sin(progress * 6 + p.rotation) * 0.05) * size.width;
      final currentRot = p.rotation + p.rotationSpeed * progress;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(currentRot);

      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      if (p.isHeart) {
        final path = Path();
        final s = p.size * 0.6;
        path.moveTo(0, 0);
        path.cubicTo(-s, -s, -s * 1.3, s * 0.5, 0, s * 1.3);
        path.cubicTo(s * 1.3, s * 0.5, s, -s, 0, 0);
        canvas.drawPath(path, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset.zero, width: p.size, height: p.size * 0.6),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
