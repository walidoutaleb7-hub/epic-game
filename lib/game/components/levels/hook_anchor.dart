import 'dart:math' as math;
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../../utils/constants.dart';

class HookAnchor extends BodyComponent {
  double _t = 0;
  double _radius;
  bool isInRange = false;

  HookAnchor(Vector2 position, {double radius = 0.5})
      : _radius = radius,
        super(
          bodyDef: BodyDef()
            ..type = BodyType.static
            ..position = position,
        );

  @override
  Body createBody() {
    final shape = CircleShape()..radius = _radius;
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
    final pulse = math.sin(_t) * 0.15 + 1.0;
    final color = isInRange ? const Color(0xFFFFD700) : const Color(0xFF90A4AE);

    // هالة
    canvas.drawCircle(
      Offset.zero,
      _radius * 1.8 * pulse,
      Paint()
        ..color = color.withValues(alpha: isInRange ? 0.5 : 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // حلقة خارجية
    canvas.drawCircle(
      Offset.zero,
      _radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.1,
    );

    // نقطة داخلية
    canvas.drawCircle(
      Offset.zero,
      _radius * 0.5,
      Paint()..color = color,
    );

    // علامة الخطاف
    canvas.drawCircle(
      Offset.zero,
      _radius * 0.2,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}
