import 'dart:ui';
import 'package:flame/components.dart';

class ParallaxBackground extends PositionComponent {
  double _scrollX = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _scrollX += dt * 20;
  }

  @override
  void render(Canvas canvas) {
    // طبقة الجبال البعيدة
    final farPaint = Paint()..color = const Color(0xFF1A1F3A);
    final farPath = Path()..moveTo(-100, 15);
    for (double x = -100; x < 100; x += 8) {
      final y = 12 + (x + _scrollX * 0.3).abs() % 6 - 3;
      farPath.lineTo(x, y);
    }
    farPath
      ..lineTo(100, 20)
      ..lineTo(-100, 20)
      ..close();
    canvas.drawPath(farPath, farPaint);

    // طبقة الجبال القريبة
    final nearPaint = Paint()..color = const Color(0xFF2A2F4A);
    final nearPath = Path()..moveTo(-100, 17);
    for (double x = -100; x < 100; x += 6) {
      final y = 14 + (x + _scrollX * 0.6).abs() % 5 - 2.5;
      nearPath.lineTo(x, y);
    }
    nearPath
      ..lineTo(100, 22)
      ..lineTo(-100, 22)
      ..close();
    canvas.drawPath(nearPath, nearPaint);

    // نجوم في السماء
    for (int i = 0; i < 60; i++) {
      final sx = ((i * 37) % 200 - 100) + (_scrollX * 0.1) % 200;
      final sy = ((i * 53) % 12) - 6;
      canvas.drawCircle(
        Offset(sx.toDouble(), sy.toDouble()),
        0.05 + (i % 3) * 0.03,
        Paint()..color = const Color(0xFFFFD700).withValues(alpha: 0.6),
      );
    }
  }
}
