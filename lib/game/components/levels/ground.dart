import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';

class Ground extends BodyComponent {
  final Vector2 _position;
  final Vector2 _size;

  Ground(this._position, this._size);

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(_size.x / 2, _size.y / 2);
    final fixture = FixtureDef(shape, friction: 0.6, restitution: 0.0);
    final bodyDef = BodyDef(position: _position, type: BodyType.static);
    return world.createBody(bodyDef!)..createFixture(fixture);
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: _size.x,
      height: _size.y,
    );

    // ظل
    canvas.drawRect(
      rect.shift(const Offset(0, 0.08)),
      Paint()..color = const Color(0x59000000),
    );

    // جسم الأرضية
    canvas.drawRect(rect, Paint()..color = const Color(0xFF2E7D32));

    // حافة علوية مضيئة
    canvas.drawLine(
      rect.topLeft,
      rect.topRight,
      Paint()
        ..color = const Color(0xFF66BB6A)
        ..strokeWidth = 0.06,
    );
  }
}
