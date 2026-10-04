import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

class HealthPotion extends PositionComponent {
  double _t = 0;

  HealthPotion(Vector2 position)
      : super(
          position: position,
          size: Vector2(35, 45),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt * 2;
  }

  @override
  void render(Canvas canvas) {
    final offset = math.sin(_t) * 4;
    canvas.save();
    canvas.translate(0, offset);

    canvas.drawCircle(
      Offset.zero,
      22,
      Paint()
        ..color = const Color(0xFF4CAF50).withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-12, -18, 24, 36),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF66BB6A),
    );

    canvas.drawRect(
      const Rect.fromLTWH(-8, -22, 16, 6),
      Paint()..color = const Color(0xFF795548),
    );

    final plusPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-6, 0), const Offset(6, 0), plusPaint);
    canvas.drawLine(const Offset(0, -6), const Offset(0, 6), plusPaint);

    canvas.restore();
  }
}
