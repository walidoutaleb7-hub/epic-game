import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class Player extends BodyComponent {
  static const double _speed = 14;
  static const double _jumpForce = 42;
  static const double _dashSpeed = 36;

  double _horizontalInput = 0;
  bool _isGrounded = false;
  bool _canDoubleJump = true;
  double _dashTimer = 0;
  double _dashCooldown = 0;
  double _attackTimer = 0;
  bool _facingRight = true;

  Player(Vector2 position)
      : super(
          bodyDef: BodyDef()
            ..type = BodyType.dynamic
            ..position = position
            ..fixedRotation = true
            ..linearDamping = 0.1,
        );

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(0.6, 0.9);
    final fixture = FixtureDef(shape, friction: 0.1, density: 1.0);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

  void setHorizontal(double x) {
    _horizontalInput = x;
    if (x > 0.1) _facingRight = true;
    if (x < -0.1) _facingRight = false;
  }

  void jump() {
    if (_isGrounded) {
      body.applyLinearImpulse(Vector2(0, -_jumpForce));
      _canDoubleJump = true;
    } else if (_canDoubleJump) {
      body.linearVelocity = Vector2(body.linearVelocity.x, 0);
      body.applyLinearImpulse(Vector2(0, -_jumpForce * 0.85));
      _canDoubleJump = false;
    }
  }

  void dash() {
    if (_dashCooldown <= 0) {
      _dashTimer = 0.18;
      _dashCooldown = 0.7;
    }
  }

  void attack() {
    _attackTimer = 0.25;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_dashTimer > 0) _dashTimer -= dt;
    if (_dashCooldown > 0) _dashCooldown -= dt;
    if (_attackTimer > 0) _attackTimer -= dt;

    _isGrounded =
        body.linearVelocity.y.abs() < 0.5 && body.position.y < 7.0;
    if (_isGrounded) _canDoubleJump = true;

    if (_dashTimer > 0) {
      final dir = _horizontalInput != 0
          ? _horizontalInput.sign
          : (_facingRight ? 1.0 : -1.0);
      body.linearVelocity =
          Vector2(dir * _dashSpeed, body.linearVelocity.y * 0.15);
    } else if (_horizontalInput.abs() > 0.15) {
      body.linearVelocity =
          Vector2(_horizontalInput * _speed, body.linearVelocity.y);
    } else {
      body.linearVelocity =
          Vector2(body.linearVelocity.x * 0.75, body.linearVelocity.y);
    }
  }

  @override
  void render(Canvas canvas) {
    // ظل
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, 1.05),
        width: 1.2,
        height: 0.25,
      ),
      Paint()..color = const Color(0x59000000),
    );

    // هالة الاندفاع
    if (_dashTimer > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-0.75, -1.05, 1.5, 2.1),
          const Radius.circular(8),
        ),
        Paint()
          ..color = const Color(0x804FC3F7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // جسم اللاعب
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4FC3F7), Color(0xFF1565C0)],
      ).createShader(const Rect.fromLTWH(-0.6, -0.9, 1.2, 1.8));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-0.6, -0.9, 1.2, 1.8),
        const Radius.circular(6),
      ),
      bodyPaint,
    );

    // العيون
    final eyeOffset = _facingRight ? 0.1 : -0.1;
    final eyeWhite = Paint()..color = const Color(0xFFFFFFFF);
    final pupil = Paint()..color = const Color(0xFF000000);
    canvas.drawCircle(Offset(-0.2 + eyeOffset, -0.4), 0.13, eyeWhite);
    canvas.drawCircle(Offset(0.2 + eyeOffset, -0.4), 0.13, eyeWhite);
    canvas.drawCircle(Offset(-0.2 + eyeOffset, -0.35), 0.06, pupil);
    canvas.drawCircle(Offset(0.2 + eyeOffset, -0.35), 0.06, pupil);

    // تأثير الهجوم
    if (_attackTimer > 0) {
      final attackDir = _facingRight ? 1.0 : -1.0;
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(attackDir * 0.8, 0),
          radius: 0.9,
        ),
        _facingRight ? -1.2 : 2.0,
        1.4,
        false,
        Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.15,
      );
    }
  }
}
