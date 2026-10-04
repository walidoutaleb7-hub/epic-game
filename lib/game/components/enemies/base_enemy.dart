import 'dart:ui';

import 'package:flame/components.dart';

class BaseEnemy extends PositionComponent with HasGameReference {
  final Vector2 startPos;
  final double patrolRange;
  int health;
  final int maxHealth;
  double _dir = 1.0;
  double _hitTimer = 0;
  double _t = 0;

  BaseEnemy(Vector2 position, {this.patrolRange = 200, this.health = 30})
      : startPos = position.clone(),
        maxHealth = health,
        super(
          position: position,
          size: Vector2(40, 40),
          anchor: Anchor.center,
        );

  void takeDamage(int dmg) {
    health -= dmg;
    _hitTimer = 0.3;
    if (health <= 0) removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_hitTimer > 0) _hitTimer -= dt;
    _t += dt;

    position.x += _dir * 60 * dt;
    if ((position.x - startPos.x).abs() > patrolRange) _dir *= -1;
  }

  @override
  void render(Canvas canvas) {
    final hit = _hitTimer > 0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 40, height: 40),
        const Radius.circular(8),
      ),
      Paint()
        ..color = hit
            ? const Color(0xFFFFFFFF)
            : (health > maxHealth / 2
                ? const Color(0xFFE53935)
                : const Color(0xFF8B0000)),
    );
    // عيون
    canvas.drawCircle(
      const Offset(-7, -5),
      5,
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawCircle(
      const Offset(7, -5),
      5,
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawCircle(
      const Offset(-7, -5),
      2.5,
      Paint()..color = const Color(0xFF000000),
    );
    canvas.drawCircle(
      const Offset(7, -5),
      2.5,
      Paint()..color = const Color(0xFF000000),
    );
  }
}
