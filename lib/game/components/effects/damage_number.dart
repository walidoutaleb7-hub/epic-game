import 'dart:ui';
import 'package:flame/components.dart';

class DamageNumber extends PositionComponent {
  final int damage;
  final bool isCrit;
  double _timer = 0;
  static const double _duration = 0.9;

  DamageNumber(Vector2 position, this.damage, {this.isCrit = false}) {
    this.position = position;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    position.y -= dt * 2.0;
    if (_timer >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final alpha = (1 - _timer / _duration).clamp(0.0, 1.0);
    final color = isCrit
        ? const Color(0xFFFFEB3B)
        : const Color(0xFFFFFFFF);
    final size = isCrit ? 0.6 : 0.45;

    final tp = TextPainter(
      text: TextSpan(
        text: isCrit ? '$damage!' : '$damage',
        style: TextStyle(
          color: color.withValues(alpha: alpha),
          fontSize: size * 20,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(color: Color(0xFF000000), blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(-tp.width / 2 / 20, -tp.height / 2 / 20));
  }
}
