import 'dart:ui';

import 'package:flame/components.dart';

class ParallaxBackground extends PositionComponent with HasGameReference {
  double _scrollX = 0;

  ParallaxBackground() : super(priority: -100);

  @override
  void update(double dt) {
    super.update(dt);
    _scrollX += dt * 20;
  }

  @override
  void render(Canvas canvas) {
    final camX = -game.camera.viewfinder.position.x;
    final camY = -game.camera.viewfinder.position.y;

    // نجوم
    for (int i = 0; i < 80; i++) {
      final sx = ((i * 37) % 800 - 400) + camX * 0.1 + (_scrollX * 0.05) % 800;
      final sy = ((i * 53) % 400) - 200 + camY * 0.1;
      canvas.drawCircle(
        Offset(sx, sy),
        1.5 + (i % 3) * 0.8,
        Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.6),
      );
    }

    // جبال بعيدة
    final farPaint = Paint()..color = const Color(0xFF1A1F3A);
    final farPath = Path()..moveTo(-1000, 100);
    for (double x = -1000; x < 1000; x += 60) {
      final y = 40 + ((x + camX * 0.3 + _scrollX * 0.3).abs() % 60) - 30;
      farPath.lineTo(x, y + camY * 0.3);
    }
    farPath
      ..lineTo(1000, 300)
      ..lineTo(-1000, 300)
      ..close();
    canvas.drawPath(farPath, farPaint);
  }
}
