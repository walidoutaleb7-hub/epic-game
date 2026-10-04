import 'dart:math' as math;
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../../utils/constants.dart';

class Coin extends BodyComponent {
  double _t = 0;
  bool collected = false;

  Coin(Vector2 position)
      : super(
          bodyDef: BodyDef()
            ..type = BodyType.static
            ..position = position,
        );

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.3;
    final fixture = FixtureDef(shape, isSensor: true);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt * 3;
  }

  @override
  void render(Canvas canvas) {
    final scaleX = (math.cos(_t)).abs().clamp(0.15, 1.0);
    canvas.save();
    canvas.scale(scaleX, 1.0);
    canvas.drawCircle(
      Offset.zero,
      0.3,
      Paint()..color = GameConstants.goldColor,
    );
    canvas.drawCircle(
      Offset.zero,
      0.18,
      Paint()..color = const Color(0xFFFFA000),
    );
    canvas.restore();

    // هالة
    canvas.drawCircle(
      Offset.zero,
      0.35,
      Paint()
        ..color = GameConstants.goldColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }
}
