import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import 'player_animation.dart';
import 'player_state.dart';

/// نسخة اللاعب بـ Sprite (تُضاف كطفل للجسم الفيزيائي)
class PlayerSprite extends BodyComponent {
  late PlayerAnimation anim;
  double _hitTimer = 0;

  PlayerSprite(Vector2 position)
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
    final fixture = FixtureDef(
      shape,
      friction: 0.1,
      density: 1.0,
      isSensor: true,
    );
    return world.createBody(bodyDef!)..createFixture(fixture);
  }

  @override
  Future<void> onLoad() async {
    anim = PlayerAnimation();
    await add(anim);
  }

  void setHit() => _hitTimer = 0.3;

  @override
  void update(double dt) {
    super.update(dt);
    if (_hitTimer > 0) _hitTimer -= dt;

    // رسم الهالة عند الضرر فقط
    if (_hitTimer > 0) {
      final opacity = _hitTimer / 0.3;
      // الوميض
      if ((_hitTimer * 10).toInt() % 2 == 0) {
        anim.opacity = 0.3;
      } else {
        anim.opacity = 1.0;
      }
    } else {
      anim.opacity = 1.0;
    }
  }

  @override
  void render(Canvas canvas) {
    // ما نرسمش — الأنيميشن يتكفل
  }

  void playAnim(PlayerState state, {bool facingRight = true}) {
    anim.playState(state, facingRight: facingRight, isHit: _hitTimer > 0);
  }
}
