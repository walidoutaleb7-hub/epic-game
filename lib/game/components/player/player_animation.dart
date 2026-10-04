import 'package:flame/components.dart';

import 'player_state.dart';

class PlayerAnimation extends SpriteAnimationComponent {
  static const String _basePath = 'player/Main Characters/Virtual Guy/';

  late SpriteAnimation idle;
  late SpriteAnimation run;
  late SpriteAnimation jump;
  late SpriteAnimation fall;
  late SpriteAnimation doubleJump;
  late SpriteAnimation hit;
  late SpriteAnimation wallJump;

  PlayerState _lastState = PlayerState.idle;
  bool _facingRight = true;
  bool _wasHit = false;

  PlayerAnimation()
      : super(
          size: Vector2(1.6, 1.8),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    idle = await _load('Idle (32x32).png', 11, 0.12);
    run = await _load('Run (32x32).png', 12, 0.06);
    jump = await _load('Jump (32x32).png', 1, 0.1);
    fall = await _load('Fall (32x32).png', 1, 0.1);
    doubleJump = await _load('Double Jump (32x32).png', 6, 0.08);
    hit = await _load('Hit (32x32).png', 7, 0.1);
    wallJump = await _load('Wall Jump (32x32).png', 5, 0.08);

    animation = idle;
  }

  Future<SpriteAnimation> _load(String file, int frames, double stepTime) async {
    return await SpriteAnimation.load(
      '$_basePath$file',
      SpriteAnimationData.sequenced(
        amount: frames,
        stepTime: stepTime,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  void playState(PlayerState state,
      {bool facingRight = true, bool isHit = false}) {
    _facingRight = facingRight;

    if (isHit && !_wasHit) {
      _wasHit = true;
      animation = hit;
      return;
    }
    if (!isHit) _wasHit = false;

    if (state == _lastState && !isHit) return;
    _lastState = state;

    switch (state) {
      case PlayerState.idle:
        animation = idle;
        break;
      case PlayerState.running:
        animation = run;
        break;
      case PlayerState.jumping:
        animation = jump;
        break;
      case PlayerState.falling:
        animation = fall;
        break;
      case PlayerState.dashing:
        animation = run;
        break;
      case PlayerState.wallSliding:
        animation = wallJump;
        break;
      case PlayerState.hooking:
        animation = doubleJump;
        break;
      case PlayerState.attacking:
        animation = run;
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    scale.x = _facingRight ? 1.0 : -1.0;
  }
}
