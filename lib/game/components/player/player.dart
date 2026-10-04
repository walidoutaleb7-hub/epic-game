import 'dart:ui';

import 'package:flame/components.dart';

import 'player_animation.dart';
import 'player_state.dart';

class Player extends PositionComponent with HasGameReference {
  static const double _speed = 220;
  static const double _jumpV = -520;
  static const double _dashSpeed = 700;
  static const double _gravity = 1200;
  static const double _maxFall = 700;
  static const double _hookPull = 400;

  Vector2 velocity = Vector2.zero();
  double _horizontalInput = 0;
  PlayerState _state = PlayerState.idle;
  bool _isGrounded = false;
  bool _canDoubleJump = true;
  double _dashTimer = 0;
  double _dashCooldown = 0;
  double _attackTimer = 0;
  double _hitTimer = 0;
  bool _facingRight = true;
  bool _isHooking = false;
  Vector2? _hookTarget;
  Vector2? _hookFrom;

  late PlayerAnimation anim;

  Player(Vector2 position)
      : super(
          position: position,
          size: Vector2(40, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    anim = PlayerAnimation();
    await add(anim);
  }

  PlayerState get state => _state;
  bool get isFacingRight => _facingRight;
  bool get isHooking => _isHooking;
  Vector2? get hookTarget => _hookTarget;
  Vector2? get hookFrom => _hookFrom;
  bool get isHit => _hitTimer > 0;

  void setHorizontal(double x) {
    _horizontalInput = x;
    if (x > 0.1) _facingRight = true;
    if (x < -0.1) _facingRight = false;
  }

  void jump() {
    if (_isGrounded) {
      velocity.y = _jumpV;
      _canDoubleJump = true;
    } else if (_canDoubleJump) {
      velocity.y = _jumpV * 0.85;
      _canDoubleJump = false;
    }
  }

  void dash() {
    if (_dashCooldown <= 0) {
      _dashTimer = 0.15;
      _dashCooldown = 0.7;
    }
  }

  void attack() => _attackTimer = 0.25;
  void takeHit() => _hitTimer = 0.4;

  void startHook(Vector2 target) {
    if (_isHooking) return;
    _isHooking = true;
    _hookTarget = target.clone();
    _hookFrom = position.clone();
  }

  void releaseHook() {
    _isHooking = false;
    _hookTarget = null;
    _hookFrom = null;
  }

  /// فحص الأرضيات — يُستدعى من اللعبة
  void setGrounded(bool g) {
    _isGrounded = g;
    if (g) _canDoubleJump = true;
  }

  bool checkCollides(Rect other) {
    final myRect = Rect.fromCenter(
      center: Offset(position.x, position.y),
      width: size.x,
      height: size.y,
    );
    return myRect.overlaps(other);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_dashTimer > 0) _dashTimer -= dt;
    if (_dashCooldown > 0) _dashCooldown -= dt;
    if (_attackTimer > 0) _attackTimer -= dt;
    if (_hitTimer > 0) _hitTimer -= dt;

    if (_isHooking && _hookTarget != null) {
      final diff = _hookTarget! - position;
      final d = diff.length;
      if (d < 15) {
        releaseHook();
        velocity *= 0.3;
      } else {
        final dir = diff.normalized();
        velocity = dir * _hookPull;
      }
      _state = PlayerState.hooking;
      position += velocity * dt;
      _updateAnim();
      return;
    }

    if (_dashTimer > 0) {
      final dir = _horizontalInput != 0
          ? _horizontalInput.sign
          : (_facingRight ? 1.0 : -1.0);
      velocity.x = dir * _dashSpeed;
      velocity.y = 0;
      _state = PlayerState.dashing;
    } else {
      velocity.x = _horizontalInput * _speed;
      velocity.y += _gravity * dt;
      if (velocity.y > _maxFall) velocity.y = _maxFall;

      if (_isGrounded) {
        if (_horizontalInput.abs() > 0.15) {
          _state = PlayerState.running;
        } else {
          _state = PlayerState.idle;
        }
      } else {
        _state = velocity.y < 0 ? PlayerState.jumping : PlayerState.falling;
      }
    }

    position += velocity * dt;
    _updateAnim();
  }

  void _updateAnim() {
    anim.playState(_state, facingRight: _facingRight, isHit: _hitTimer > 0);
  }
}
