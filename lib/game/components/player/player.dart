import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import 'player_state.dart';

class Player extends BodyComponent {
  // إعدادات الحركة
  static const double _speed = 14;
  static const double _jumpForce = 42;
  static const double _dashSpeed = 36;
  static const double _wallSlideSpeed = 4;
  static const double _wallJumpPush = 18;
  static const double _hookPullSpeed = 28;
  static const double _hookMaxRange = 12;

  // مدخلات
  double _horizontalInput = 0;
  bool _jumpPressed = false;
  bool _dashPressed = false;
  bool _attackPressed = false;
  bool _hookPressed = false;

  // حالة
  PlayerState _state = PlayerState.idle;
  bool _isGrounded = false;
  bool _canDoubleJump = true;
  bool _isTouchingWall = false;
  int _wallSide = 0; // -1 يسار، 1 يمين، 0 لا
  double _dashTimer = 0;
  double _dashCooldown = 0;
  double _attackTimer = 0;
  double _wallJumpCooldown = 0;
  bool _facingRight = true;

  // الخطاف
  bool _isHooking = false;
  Vector2? _hookTarget;
  Vector2? _hookFrom;

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

  // Getters للاستعمال الخارجي
  PlayerState get state => _state;
  bool get isFacingRight => _facingRight;
  bool get isHooking => _isHooking;
  Vector2? get hookTarget => _hookTarget;
  Vector2? get hookFrom => _hookFrom;

  // ============ المدخلات ============
  void setHorizontal(double x) {
    _horizontalInput = x;
    if (x > 0.1) _facingRight = true;
    if (x < -0.1) _facingRight = false;
  }

  void jump() {
    if (_isTouchingWall && !_isGrounded && _wallJumpCooldown <= 0) {
      // Wall jump
      final pushDir = -_wallSide.toDouble();
      body.linearVelocity = Vector2(pushDir * _wallJumpPush, -_jumpForce * 0.9);
      _wallJumpCooldown = 0.2;
      _canDoubleJump = true;
      return;
    }
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

  void startHook(Vector2 target) {
    if (_isHooking) return;
    _isHooking = true;
    _hookTarget = target.clone();
    _hookFrom = body.position.clone();
  }

  void releaseHook() {
    _isHooking = false;
    _hookTarget = null;
    _hookFrom = null;
  }

  // ============ التحديث ============
  @override
  void update(double dt) {
    super.update(dt);

    if (_dashTimer > 0) _dashTimer -= dt;
    if (_dashCooldown > 0) _dashCooldown -= dt;
    if (_attackTimer > 0) _attackTimer -= dt;
    if (_wallJumpCooldown > 0) _wallJumpCooldown -= dt;

    // كشف الحيطان
    _detectWall();

    // كشف الأرض
    _isGrounded = body.linearVelocity.y.abs() < 0.5 &&
        body.position.y > _lastGroundY - 0.5;
    if (_isGrounded) {
      _canDoubleJump = true;
      _lastGroundY = body.position.y;
    }

    // الخطاف له الأولوية
    if (_isHooking && _hookTarget != null) {
      _updateHook(dt);
      _state = PlayerState.hooking;
      return;
    }

    // الاندفاع
    if (_dashTimer > 0) {
      final dir = _horizontalInput != 0
          ? _horizontalInput.sign
          : (_facingRight ? 1.0 : -1.0);
      body.linearVelocity =
          Vector2(dir * _dashSpeed, body.linearVelocity.y * 0.15);
      _state = PlayerState.dashing;
      return;
    }

    // التسلق على الحيط (Wall Slide)
    if (_isTouchingWall && !_isGrounded && body.linearVelocity.y > 0) {
      body.linearVelocity =
          Vector2(body.linearVelocity.x * 0.3, _wallSlideSpeed);
      _state = PlayerState.wallSliding;
      return;
    }

    // الحركة العادية
    if (_horizontalInput.abs() > 0.15) {
      body.linearVelocity =
          Vector2(_horizontalInput * _speed, body.linearVelocity.y);
      _state = _isGrounded ? PlayerState.running : PlayerState.jumping;
    } else {
      body.linearVelocity =
          Vector2(body.linearVelocity.x * 0.75, body.linearVelocity.y);
      if (_isGrounded) {
        _state = PlayerState.idle;
      } else if (body.linearVelocity.y > 0) {
        _state = PlayerState.falling;
      } else {
        _state = PlayerState.jumping;
      }
    }
  }

  double _lastGroundY = 0;

  void _detectWall() {
    // كشف الحيط باستعمال raycasts بسيطة
    final pos = body.position;
    _isTouchingWall = false;
    _wallSide = 0;

    // Raycast يمين
    final rightHit = world.raycast(
      Ray(Vector2(pos.x, pos.y), Vector2(1, 0)),
      maxDistance: 0.75,
    );
    if (rightHit != null) {
      _isTouchingWall = true;
      _wallSide = 1;
      return;
    }

    // Raycast يسار
    final leftHit = world.raycast(
      Ray(Vector2(pos.x, pos.y), Vector2(-1, 0)),
      maxDistance: 0.75,
    );
    if (leftHit != null) {
      _isTouchingWall = true;
      _wallSide = -1;
    }
  }

  void _updateHook(double dt) {
    if (_hookTarget == null) return;

    final diff = _hookTarget! - body.position;
    final distance = diff.length;

    if (distance < 0.8) {
      // وصلنا
      releaseHook();
      body.linearVelocity = Vector2(body.linearVelocity.x * 0.5, 0);
      return;
    }

    final dir = diff.normalized();
    body.linearVelocity = dir * _hookPullSpeed;
  }

  // ============ الرسم ============
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
    if (_state == PlayerState.dashing) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-0.8, -1.05, 1.6, 2.1),
          const Radius.circular(8),
        ),
        Paint()
          ..color = const Color(0x804FC3F7)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // هالة التسلق
    if (_state == PlayerState.wallSliding) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-0.65, -0.95, 1.3, 1.9),
          const Radius.circular(6),
        ),
        Paint()
          ..color = const Color(0x80FFC107)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
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

    // رسم الخطاف
    if (_isHooking && _hookFrom != null && _hookTarget != null) {
      final localFrom = _hookFrom! - body.position;
      final localTo = _hookTarget! - body.position;
      canvas.drawLine(
        Offset(localFrom.x, localFrom.y),
        Offset(localTo.x, localTo.y),
        Paint()
          ..color = const Color(0xFFFFD700)
          ..strokeWidth = 0.1,
      );
      canvas.drawCircle(
        Offset(localTo.x, localTo.y),
        0.15,
        Paint()..color = const Color(0xFFFFD700),
      );
    }
  }
}
