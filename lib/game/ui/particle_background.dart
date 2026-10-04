import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 80; i++) {
      _stars.add(_Star(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: _rng.nextDouble() * 2 + 0.5,
        speed: _rng.nextDouble() * 0.5 + 0.2,
        alpha: _rng.nextDouble() * 0.6 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarPainter(_stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  double x, y, size, speed, alpha;
  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.alpha,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double t;

  _StarPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final y = (s.y + t * s.speed) % 1.0;
      final paint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: s.alpha * (0.5 + 0.5 * math.sin(t * math.pi * 2 + s.x * 10)));
      canvas.drawCircle(
        Offset(s.x * size.width, y * size.height),
        s.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => true;
}
