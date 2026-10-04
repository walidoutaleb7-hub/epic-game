import 'dart:ui';

import 'package:flame/components.dart';

class DashTrail extends PositionComponent {
  double _timer = 0;
  static const double _duration = 0.3;

  DashTrail(Vector2 position)
      : super(
          position: position,
          size: Vector2(40, 50),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final alpha = (1 - _timer / _duration).clamp(0.0, 1.0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 40, height: 50),
        const Radius.circular(8),
      ),
      Paint()
        ..color = const Color(0xFF4FC3F7).withValues(alpha: alpha * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }
}
