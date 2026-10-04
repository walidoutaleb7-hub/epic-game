import 'dart:ui';

import 'package:flame/components.dart';

class Ground extends PositionComponent {
  final Vector2 _size;

  Ground(Vector2 position, this._size)
      : super(
          position: position,
          size: _size,
          anchor: Anchor.center,
        );

  Rect get rect => Rect.fromCenter(
        center: Offset(position.x, position.y),
        width: size.x,
        height: size.y,
      );

  @override
  void render(Canvas canvas) {
    final r = Rect.fromCenter(
      center: Offset.zero,
      width: size.x,
      height: size.y,
    );
    // ظل
    canvas.drawRect(
      r.shift(const Offset(0, 4)),
      Paint()..color = const Color(0x55000000),
    );
    // جسم
    canvas.drawRect(r, Paint()..color = const Color(0xFF2E7D32));
    // حافة
    canvas.drawLine(
      r.topLeft,
      r.topRight,
      Paint()
        ..color = const Color(0xFF66BB6A)
        ..strokeWidth = 2,
    );
  }
}
