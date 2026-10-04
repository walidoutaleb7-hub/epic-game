import 'dart:math' as math;
import 'package:flame/components.dart';

class CameraShake {
  double _intensity = 0;
  double _duration = 0;
  double _elapsed = 0;
  final math.Random _rng = math.Random();

  bool get isActive => _intensity > 0;

  void shake({double intensity = 0.5, double duration = 0.3}) {
    _intensity = intensity;
    _duration = duration;
    _elapsed = 0;
  }

  Vector2 get offset {
    if (!isActive) return Vector2.zero();
    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    final currentIntensity = _intensity * (1 - progress);
    return Vector2(
      (_rng.nextDouble() - 0.5) * 2 * currentIntensity,
      (_rng.nextDouble() - 0.5) * 2 * currentIntensity,
    );
  }

  void update(double dt) {
    if (!isActive) return;
    _elapsed += dt;
    if (_elapsed >= _duration) {
      _intensity = 0;
      _elapsed = 0;
    }
  }
}
