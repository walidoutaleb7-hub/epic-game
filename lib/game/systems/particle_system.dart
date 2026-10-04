import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';

class Particle {
  Vector2 position;
  Vector2 velocity;
  double life;
  double maxLife;
  double size;
  Color color;
  double gravity;

  Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.size,
    required this.color,
    this.gravity = 200,
  }) : maxLife = life;

  bool get isDead => life <= 0;
}

class ParticleSystem extends Component {
  final List<Particle> particles = [];
  final math.Random _rng = math.Random();

  void spawnBurst(
    Vector2 position, {
    int count = 12,
    Color color = const Color(0xFFFFD700),
    double speed = 150,
    double size = 0.15,
  }) {
    for (int i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * math.pi * 2;
      final s = speed * (0.5 + _rng.nextDouble() * 0.5);
      particles.add(Particle(
        position: position.clone(),
        velocity: Vector2(math.cos(angle) * s, math.sin(angle) * s),
        life: 0.4 + _rng.nextDouble() * 0.5,
        size: size * (0.7 + _rng.nextDouble() * 0.6),
        color: color,
      ));
    }
  }

  void spawnDust(Vector2 position, {int count = 5}) {
    for (int i = 0; i < count; i++) {
      particles.add(Particle(
        position: position.clone(),
        velocity: Vector2(
          (_rng.nextDouble() - 0.5) * 80,
          -_rng.nextDouble() * 60,
        ),
        life: 0.3 + _rng.nextDouble() * 0.3,
        size: 0.1 + _rng.nextDouble() * 0.1,
        color: const Color(0x88AAAAAA),
        gravity: 50,
      ));
    }
  }

  void spawnTrail(Vector2 position, Color color) {
    particles.add(Particle(
      position: position.clone(),
      velocity: Vector2(
        (_rng.nextDouble() - 0.5) * 20,
        (_rng.nextDouble() - 0.5) * 20,
      ),
      life: 0.3,
      size: 0.2,
      color: color,
      gravity: 0,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in particles) {
      p.life -= dt;
      p.velocity.y += p.gravity * dt;
      p.position += p.velocity * dt;
    }
    particles.removeWhere((p) => p.isDead);
  }

  @override
  void render(Canvas canvas) {
    for (final p in particles) {
      final alpha = (p.life / p.maxLife).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(p.position.x, p.position.y),
        p.size * alpha,
        Paint()..color = p.color.withValues(alpha: alpha),
      );
    }
  }
}
