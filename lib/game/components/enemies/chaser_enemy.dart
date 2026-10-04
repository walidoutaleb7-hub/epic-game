import 'dart:ui';

import 'package:flame/components.dart';

class ChaserEnemy extends PositionComponent with HasGameReference {
  int health;
  final int maxHealth;
  double _hitTimer = 0;
  bool _isAggro = false;
  final double _aggroRange = 350;

  ChaserEnemy(Vector2 position, {this.health = 50})
      : maxHealth = health,
        super(
          position: position,
          size: Vector2(45, 45),
          anchor: Anchor.center,
        );

  void takeDamage(int dmg) {
    health -= dmg;
    _hitTimer = 0.3;
    _isAggro = true;
    if (health <= 0) removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_hitTimer > 0) _hitTimer -= dt;

    final player = game.children.whereType<PositionComponent>()
        .where((c) => c.runtimeType.toString() == 'Player')
        .firstOrNull;
    if (player == null) return;

    final diff = player.position - position;
    final dist = diff.length;

    if (dist < _aggroRange) _isAggro = true;
    if (dist > _aggroRange * 2) _isAggro = false;

    if (_isAggro && dist > 10) {
      final dir = diff.normalized();
      position += dir * 120 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    final hit = _hitTimer > 0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 45, height: 45),
        const Radius.circular(8),
      ),
      Paint()
        ..color = hit ? const Color(0xFFFFFFFF) : const Color(0xFF7B1FA2),
    );
    canvas.drawCircle(
      const Offset(-8, -5),
      5,
      Paint()..color = const Color(0xFFFFEB3B),
    );
    canvas.drawCircle(
      const Offset(8, -5),
      5,
      Paint()..color = const Color(0xFFFFEB3B),
    );
    canvas.drawCircle(
      const Offset(-8, -5),
      2.5,
      Paint()..color = const Color(0xFF000000),
    );
    canvas.drawCircle(
      const Offset(8, -5),
      2.5,
      Paint()..color = const Color(0xFF000000),
    );
    if (_isAggro) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 55, height: 55),
          const Radius.circular(10),
        ),
        Paint()
          ..color = const Color(0xFFFF1744).withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }
  }
}
