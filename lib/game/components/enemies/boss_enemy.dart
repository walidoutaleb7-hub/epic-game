import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

class BossEnemy extends PositionComponent with HasGameReference {
  int health;
  final int maxHealth;
  double _hitTimer = 0;
  double _t = 0;
  bool _isPhase2 = false;

  BossEnemy(Vector2 position, {this.health = 300})
      : maxHealth = 300,
        super(
          position: position,
          size: Vector2(120, 120),
          anchor: Anchor.center,
        );

  void takeDamage(int dmg) {
    health -= dmg;
    _hitTimer = 0.2;
    if (health < maxHealth ~/ 2) _isPhase2 = true;
    if (health <= 0) removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_hitTimer > 0) _hitTimer -= dt;
    _t += dt;

    final player = game.children.whereType<PositionComponent>()
        .where((c) => c.runtimeType.toString() == 'Player')
        .firstOrNull;
    if (player == null) return;

    final diff = player.position - position;
    final dist = diff.length;
    final speed = _isPhase2 ? 140.0 : 90.0;
    if (dist > 60) {
      position += diff.normalized() * speed * dt;
    }
    position.y += math.sin(_t * 2) * 30 * dt;
  }

  @override
  void render(Canvas canvas) {
    final hit = _hitTimer > 0;
    final baseColor = _isPhase2 ? const Color(0xFFB71C1C) : const Color(0xFF4A148C);

    canvas.drawCircle(
      Offset.zero,
      80,
      Paint()
        ..color = baseColor.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: 120, height: 120),
        const Radius.circular(20),
      ),
      Paint()..color = hit ? const Color(0xFFFFFFFF) : baseColor,
    );

    // عيون
    canvas.drawCircle(
      const Offset(-20, -15),
      12,
      Paint()..color = const Color(0xFFFFEB3B),
    );
    canvas.drawCircle(
      const Offset(20, -15),
      12,
      Paint()..color = const Color(0xFFFFEB3B),
    );
    canvas.drawCircle(
      const Offset(-20, -13),
      6,
      Paint()..color = const Color(0xFF000000),
    );
    canvas.drawCircle(
      const Offset(20, -13),
      6,
      Paint()..color = const Color(0xFF000000),
    );

    // شريط صحة
    final ratio = (health / maxHealth).clamp(0.0, 1.0);
    canvas.drawRect(
      const Rect.fromLTWH(-60, -80, 120, 10),
      Paint()..color = const Color(0x99000000),
    );
    canvas.drawRect(
      Rect.fromLTWH(-60, -80, 120 * ratio, 10),
      Paint()..color = const Color(0xFFE53935),
    );
  }
}
