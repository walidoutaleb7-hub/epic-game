import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart' show Alignment;
import 'package:flutter/painting.dart' show LinearGradient;

import 'player_state.dart';

class Player extends BodyComponent {
  static const double _speed = 14;
  static const double _jumpForce = 42;
  static const double _dashSpeed = 36;
  static const double _wallSlideSpeed = 4;
  static const double _wallJumpPush = 18;
  static const double _hookPullSpeed = 28;

  double _horizontalInput = 0;
  PlayerState _state = PlayerState.idle;
  bool _isGrounded = false;
  bool _canDoubleJump = true;
  bool _isTouchingWall = false;
  int _wallSide = 0;
  double _dashTimer = 0;
  double _dashCooldown = 0;
  double _attackTimer = 0;
  double _wallJumpCooldown = 0;
  bool _facingRight = true;

  bool _isHooking = false;
  Vector2? _hookTarget;
  Vector2? _hookFrom;

  double _lastGroundY = 0;

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
    return world.createBody(bodyDef!)..createFixture(fixture);
  }

  PlayerState get state => _state;
  bool get isFacingRight => _facingRight;
  bool get isHooking => _isHooking;
  Vector2? get hookTarget => _hookTarget;
  Vector2? get hookFrom => _hookFrom;

  void setHorizontal(double x) {
    _horizontalInput = x;
    if (x > 0.1) _facingRight = true;
    if (x < -0.1) _facingRight = false;
  }

  void jump() {
    if (_isTouchingWall && !_isGrounded && _wallJumpCooldown <= 0) {
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

  void attack() => _attackTimer = 0.25;

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

  @override
  void update(double dt) {
    super.update(dt);

    if (_dashTimer > 0) _dashTimer -= dt;
    if (_dashCooldown > 0) _dashCooldown -= dt;
    if (_attackTimer > 0) _attackTimer -= dt;
    if (_wallJumpCooldown > 0) _wallJumpCooldown -= dt;

    _detectWall();

    _isGrounded = body.linearVelocity.y.abs() < 0.5 && body.position.y > _lastGroundY - 0.5;
    if (_isGrounded) {
      _canDoubleJump = true;
      _lastGroundY = body.position.y;
    }

    if (_isHooking && _hookTarget != null) {
      _updateHook(dt);
      _state = PlayerState.hooking;
      return;
    }

    if (_dashTimer > 0) {
      final dir = _horizontalInput != 0
          ? _horizontalInput.sign
          : (_facingRight ? 1.0 : -1.0);
      body.linearVelocity = Vector2(dir * _dashSpeed, body.linearVelocity.y * 0.15);
      _state = PlayerState.dashing;
      return;
    }

    if (_isTouchingWall && !_isGrounded && body.linearVelocity.y > 0) {
      body.linearVelocity = Vector2(body.linearVelocity.x * 0.3, _wallSlideSpeed);
      _state = PlayerState.wallSliding;
      return;
    }

    if (_horizontalInput.abs() > 0.15) {
      body.linearVelocity = Vector2(_horizontalInput * _speed, body.linearVelocity.y);
      _state = _isGrounded ? PlayerState.running : PlayerState.jumping;
    } else {
      body.linearVelocity = Vector2(body.linearVelocity.x * 0.75, body.linearVelocity.y);
      if (_isGrounded) {
        _state = PlayerState.idle;
      } else if (body.linearVelocity.y > 0) {
        _state = PlayerState.falling;
      } else {
        _state = PlayerState.jumping;
      }
    }
  }

  void _detectWall() {
    final px = body.position.x;
    _isTouchingWall = false;
    _wallSide = 0;
    if (px < -38.9) {
      _isTouchingWall = true;
      _wallSide = -1;
    } else if (px > 38.9) {
      _isTouchingWall = true;
      _wallSide = 1;
    }
  }

  void _updateHook(double dt) {
    if (_hookTarget == null) return;
    final diff = _hookTarget! - body.position;
    final distance = diff.length;
    if (distance < 0.8) {
      releaseHook();
      body.linearVelocity = Vector2(body.linearVelocity.x * 0.5, 0);
      return;
    }
    final dir = diff.normalized();
    body.linearVelocity = dir * _hookPullSpeed;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 1.05), width: 1.2, height: 0.25),
      Paint()..color = const Color(0x59000000),
    );

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

    final eyeOffset = _facingRight ? 0.1 : -0.1;
    final eyeWhite = Paint()..color = const Color(0xFFFFFFFF);
    final pupil = Paint()..color = const Color(0xFF000000);
    canvas.drawCircle(Offset(-0.2 + eyeOffset, -0.4), 0.13, eyeWhite);
    canvas.drawCircle(Offset(0.2 + eyeOffset, -0.4), 0.13, eyeWhite);
    canvas.drawCircle(Offset(-0.2 + eyeOffset, -0.35), 0.06, pupil);
    canvas.drawCircle(Offset(0.2 + eyeOffset, -0.35), 0.06, pupil);

    if (_attackTimer > 0) {
      final attackDir = _facingRight ? 1.0 : -1.0;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(attackDir * 0.8, 0), radius: 0.9),
        _facingRight ? -1.2 : 2.0,
        1.4,
        false,
        Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.15,
      );
    }

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
