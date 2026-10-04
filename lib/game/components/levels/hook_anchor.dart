import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

class HookAnchor extends PositionComponent {
  double _t = 0;
  bool isInRange = false;
  final double radius;

  HookAnchor(Vector2 position, {this.radius = 25})
      : super(position: position, anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt * 3;
  }

  @override
  void render(Canvas canvas) {
    final pulse = math.sin(_t) * 0.15 + 1.0;
    final color = isInRange ? const Color(0xFFFFD700) : const Color(0xFF90A4AE);

    canvas.drawCircle(
      Offset.zero,
      radius * 1.8 * pulse,
      Paint()
        ..color = color.withValues(alpha: isInRange ? 0.5 : 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(Offset.zero, radius * 0.5, Paint()..color = color);
    canvas.drawCircle(
      Offset.zero,
      radius * 0.2,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}
