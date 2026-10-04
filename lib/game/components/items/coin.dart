import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

class Coin extends PositionComponent {
  double _t = 0;
  bool collected = false;

  Coin(Vector2 position)
      : super(
          position: position,
          size: Vector2(30, 30),
          anchor: Anchor.center,
        );

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
    canvas.drawCircle(Offset.zero, 15, Paint()..color = const Color(0xFFFFD700));
    canvas.drawCircle(Offset.zero, 9, Paint()..color = const Color(0xFFFFA000));
    canvas.restore();

    canvas.drawCircle(
      Offset.zero,
      18,
      Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }
}
