import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../../utils/constants.dart';

class BaseEnemy extends BodyComponent {
  final Vector2 startPos;
  final double patrolRange;
  int health;
  final int maxHealth;
  double _dir = 1.0;
  double _hitTimer = 0;

  BaseEnemy(
    Vector2 position, {
    this.patrolRange = 4.0,
    this.health = 30,
  })  : startPos = position.clone(),
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
    final shape = PolygonShape()..setAsBoxXY(0.5, 0.5);
    final fixture = FixtureDef(shape, friction: 0.3, density: 1.0);
    return world.createBody(bodyDef!)..createFixture(fixture);
  }

  void takeDamage(int dmg) {
    health -= dmg;
    _hitTimer = 0.3;
    if (health <= 0) removeFromParent();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_hitTimer > 0) _hitTimer -= dt;

    if ((body.position.x - startPos.x).abs() > patrolRange) {
      _dir *= -1;
    }
    body.linearVelocity = Vector2(_dir * 4.0, body.linearVelocity.y);
  }

  @override
  void render(Canvas canvas) {
    final hit = _hitTimer > 0;
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: 1.0,
      height: 1.0,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()
        ..color = hit
            ? const Color(0xFFFFFFFF)
            : (health > maxHealth / 2
                ? GameConstants.enemyRed
                : GameConstants.enemyRedDark),
    );

    // عيون
    final eye = Paint()..color = const Color(0xFFFFFFFF);
    final pupil = Paint()..color = const Color(0xFF000000);
    canvas.drawCircle(const Offset(-0.2, -0.15), 0.12, eye);
    canvas.drawCircle(const Offset(0.2, -0.15), 0.12, eye);
    canvas.drawCircle(const Offset(-0.2, -0.15), 0.06, pupil);
    canvas.drawCircle(const Offset(0.2, -0.15), 0.06, pupil);

    // فم
    canvas.drawLine(
      const Offset(-0.2, 0.25),
      const Offset(0.2, 0.25),
      Paint()
        ..color = const Color(0xFF000000)
        ..strokeWidth = 0.06,
    );
  }
}
