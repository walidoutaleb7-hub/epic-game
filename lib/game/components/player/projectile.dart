import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class Projectile extends BodyComponent {
  final Vector2 direction;
  double _life = 2.0;
  bool isEnemyProjectile;

  Projectile(
    Vector2 position,
    this.direction, {
    this.isEnemyProjectile = false,
  }) : super(
          bodyDef: BodyDef()
            ..type = BodyType.dynamic
            ..position = position
            ..fixedRotation = true
            ..bullet = true,
        );

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.15;
    final fixture = FixtureDef(
      shape,
      density: 0.5,
      restitution: 0.0,
      isSensor: true,
    );
    final body = world.createBody(bodyDef)..createFixture(fixture);
    body.linearVelocity = direction.normalized() * 18.0;
    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _life -= dt;
    if (_life <= 0) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final color = isEnemyProjectile
        ? const Color(0xFFE53935)
        : const Color(0xFFFFD700);

    // هالة
    canvas.drawCircle(
      Offset.zero,
      0.35,
      Paint()
        ..color = color.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // جسم
    canvas.drawCircle(Offset.zero, 0.15, Paint()..color = color);

    // نقطة بيضاء
    canvas.drawCircle(
      Offset.zero,
      0.06,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}
