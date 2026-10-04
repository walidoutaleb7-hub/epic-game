import 'dart:math' as math;
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class BossEnemy extends BodyComponent {
  int health;
  final int maxHealth;
  double _hitTimer = 0;
  double _phaseTimer = 0;
  bool _isPhase2 = false;
  Body? target;
  final math.Random _rng = math.Random();

  BossEnemy(Vector2 position, {this.health = 300})
      : maxHealth = 300,
        super(
          bodyDef: BodyDef()
            ..type = BodyType.dynamic
            ..position = position
            ..fixedRotation = true
            ..linearDamping = 0.3,
        );

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(1.5, 1.5);
    final fixture = FixtureDef(shape, friction: 0.4, density: 3.0);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

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
    _phaseTimer += dt;

    if (target == null) return;
    final diff = target!.position - body.position;
    final distance = diff.length;
    final speed = _isPhase2 ? 7.0 : 4.5;
    final dir = diff.normalized();

    // حركة جيبية
    body.linearVelocity = Vector2(
      dir.x * speed + math.sin(_phaseTimer * 3) * 1.5,
      body.linearVelocity.y,
    );

    // قفزة دورية
    if ((_phaseTimer % 3).abs() < 0.05 && distance < 12) {
      body.applyLinearImpulse(Vector2(0, -30));
    }
  }

  @override
  void render(Canvas canvas) {
    final hit = _hitTimer > 0;
    final baseColor = _isPhase2 ? const Color(0xFFB71C1C) : const Color(0xFF4A148C);

    // ظل
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, 1.7),
        width: 3.0,
        height: 0.5,
      ),
      Paint()..color = const Color(0x66000000),
    );

    // هالة
    canvas.drawCircle(
      Offset.zero,
      2.0,
      Paint()
        ..color = baseColor.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    // الجسم
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-1.5, -1.5, 3.0, 3.0),
        const Radius.circular(12),
      ),
      Paint()..color = hit ? const Color(0xFFFFFFFF) : baseColor,
    );

    // عيون غاضبة
    final eye = Paint()..color = const Color(0xFFFFEB3B);
    canvas.drawCircle(const Offset(-0.5, -0.4), 0.3, eye);
    canvas.drawCircle(const Offset(0.5, -0.4), 0.3, eye);
    canvas.drawCircle(
      const Offset(-0.5, -0.35),
      0.15,
      Paint()..color = const Color(0xFF000000),
    );
    canvas.drawCircle(
      const Offset(0.5, -0.35),
      0.15,
      Paint()..color = const Color(0xFF000000),
    );

    // فم
    canvas.drawRect(
      const Rect.fromLTWH(-0.7, 0.4, 1.4, 0.3),
      Paint()..color = const Color(0xFF000000),
    );

    // شريط صحة الزعيم فوقو
    final hpRatio = (health / maxHealth).clamp(0.0, 1.0);
    canvas.drawRect(
      const Rect.fromLTWH(-1.5, -2.0, 3.0, 0.25),
      Paint()..color = const Color(0x99000000),
    );
    canvas.drawRect(
      Rect.fromLTWH(-1.5, -2.0, 3.0 * hpRatio, 0.25),
      Paint()..color = const Color(0xFFE53935),
    );
  }
}
