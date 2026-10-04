import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class DamageNumber extends PositionComponent {
  final int damage;
  final bool isCrit;
  double _timer = 0;
  static const double _duration = 0.9;

  DamageNumber(Vector2 position, this.damage, {this.isCrit = false})
      : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    position.y -= 40 * dt;
    if (_timer >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final alpha = (1 - _timer / _duration).clamp(0.0, 1.0);
    final color = isCrit ? const Color(0xFFFFEB3B) : const Color(0xFFFFFFFF);
    final size = isCrit ? 22.0 : 16.0;

    final tp = TextPainter(
      text: TextSpan(
        text: isCrit ? '$damage!' : '$damage',
        style: TextStyle(
          color: color.withValues(alpha: alpha),
          fontSize: size,
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(color: Color(0xFF000000), blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  }
}
