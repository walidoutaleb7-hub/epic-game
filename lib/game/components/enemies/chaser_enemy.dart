import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../../utils/constants.dart';

class ChaserEnemy extends BodyComponent {
  final Vector2 spawnPos;
  int health;
  final int maxHealth;
  double _hitTimer = 0;
  double _attackCooldown = 0;
  bool _isAggro = false;
  static const double _aggroRange = 8.0;
  static const double _chaseSpeed = 6.0;
  Body? target;

  ChaserEnemy(Vector2 position, {this.health = 50})
      : spawnPos = position.clone(),
        maxHealth = health,
        super(
          bodyDef: BodyDef()
            ..type = BodyType.dynamic
            ..position = position
            ..fixedRotation = true
            ..linearDamping = 0.5,
        );

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(0.55, 0.55);
    final fixture = FixtureDef(shape, friction: 0.3, density: 1.2);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

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
    if (_attackCooldown > 0) _attackCooldown -= dt;

    if (target == null) return;

    final diff = target!.position - body.position;
    final distance = diff.length;

    if (distance < _aggroRange) _isAggro = true;
    if (distance > _aggroRange * 2) _isAggro = false;

    if (_isAggro && distance > 0.1) {
      final dir = diff.normalized();
      body.linearVelocity = Vector2(
        dir.x * _chaseSpeed,
        body.linearVelocity.y,
      );
    } else {
      body.linearVelocity = Vector2(
        body.linearVelocity.x * 0.9,
        body.linearVelocity.y,
      );
    }
  }

  @override
  void render(Canvas canvas) {
    final hit = _hitTimer > 0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-0.55, -0.55, 1.1, 1.1),
        const Radius.circular(5),
      ),
      Paint()..color = hit ? const Color(0xFFFFFFFF) : const Color(0xFF7B1FA2),
    );

    // عيون غاضبة
    final eye = Paint()..color = const Color(0xFFFFEB3B);
    final pupil = Paint()..color = const Color(0xFF000000);
    canvas.drawCircle(const Offset(-0.2, -0.15), 0.13, eye);
    canvas.drawCircle(const Offset(0.2, -0.15), 0.13, eye);
    canvas.drawCircle(const Offset(-0.2, -0.1), 0.06, pupil);
    canvas.drawCircle(const Offset(0.2, -0.1), 0.06, pupil);

    // حواجب
    canvas.drawLine(
      const Offset(-0.3, -0.35),
      const Offset(-0.05, -0.25),
      Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 0.07,
    );
    canvas.drawLine(
      const Offset(0.3, -0.35),
      const Offset(0.05, -0.25),
      Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 0.07,
    );

    // هالة عند الغضب
    if (_isAggro) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-0.7, -0.7, 1.4, 1.4),
          const Radius.circular(8),
        ),
        Paint()
          ..color = const Color(0xFFFF1744).withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }
}
