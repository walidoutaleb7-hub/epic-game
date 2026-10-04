import 'dart:math' as math;
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class HealthPotion extends BodyComponent {
  double _t = 0;

  HealthPotion(Vector2 position)
      : super(
          bodyDef: BodyDef()
            ..type = BodyType.static
            ..position = position,
        );

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 0.35;
    final fixture = FixtureDef(shape, isSensor: true);
    return world.createBody(bodyDef!)..createFixture(fixture);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt * 2;
  }

  @override
  void render(Canvas canvas) {
    final offset = math.sin(_t) * 0.1;
    canvas.save();
    canvas.translate(0, offset);

    // هالة خضراء
    canvas.drawCircle(
      Offset.zero,
      0.45,
      Paint()
        ..color = const Color(0xFF4CAF50).withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // قارورة
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-0.25, -0.35, 0.5, 0.7),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF66BB6A),
    );

    // سدادة
    canvas.drawRect(
      const Rect.fromLTWH(-0.15, -0.45, 0.3, 0.12),
      Paint()..color = const Color(0xFF795548),
    );

    // علامة +
    final plusPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 0.08
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(-0.12, 0),
      const Offset(0.12, 0),
      plusPaint,
    );
    canvas.drawLine(
      const Offset(0, -0.12),
      const Offset(0, 0.12),
      plusPaint,
    );

    canvas.restore();
  }
}
