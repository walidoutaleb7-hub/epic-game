import 'dart:ui';
import 'package:flame/components.dart';

class HitEffect extends PositionComponent {
  double _timer = 0;
  static const double _duration = 0.25;

  HitEffect(Vector2 position) {
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
    final progress = (_timer / _duration).clamp(0.0, 1.0);
    final radius = 0.3 + progress * 1.5;
    final alpha = 1.0 - progress;

    // حلقة خارجية
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.15 * (1 - progress),
    );

    // وهج
    canvas.drawCircle(
      Offset.zero,
      radius * 0.7,
      Paint()
        ..color = const Color(0xFFFF5252).withValues(alpha: alpha * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }
}
