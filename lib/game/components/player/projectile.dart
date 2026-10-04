import 'dart:ui';

import 'package:flame/components.dart';

class Projectile extends PositionComponent with HasGameReference {
  final Vector2 direction;
  double _life = 1.5;

  Projectile(Vector2 position, this.direction)
      : super(
          position: position,
          size: Vector2(20, 20),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    _life -= dt;
    if (_life <= 0) removeFromParent();
    position += direction.normalized() * 500 * dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      12,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(Offset.zero, 6, Paint()..color = const Color(0xFFFFD700));
    canvas.drawCircle(
      Offset.zero,
      2.5,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}
