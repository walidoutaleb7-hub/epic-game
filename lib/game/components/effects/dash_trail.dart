import 'dart:ui';
import 'package:flame/components.dart';

class DashTrail extends PositionComponent {
  double _timer = 0;
  static const double _duration = 0.3;

  DashTrail(Vector2 position) {
    this.position = position;
  }

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
        const Rect.fromLTWH(-0.6, -0.9, 1.2, 1.8),
        const Radius.circular(6),
      ),
      Paint()
        ..color = const Color(0xFF4FC3F7).withValues(alpha: alpha * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }
}
