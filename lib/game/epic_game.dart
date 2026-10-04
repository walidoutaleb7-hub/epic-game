import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'components/effects/damage_number.dart';
import 'components/effects/dash_trail.dart';
import 'components/effects/hit_effect.dart';
import 'components/enemies/base_enemy.dart';
import 'components/enemies/boss_enemy.dart';
import 'components/enemies/chaser_enemy.dart';
import 'components/items/coin.dart';
import 'components/items/health_potion.dart';
import 'components/levels/ground.dart';
import 'components/levels/parallax_background.dart';
import 'components/player/player.dart';
import 'systems/achievement_system.dart';
import 'systems/camera_shake.dart';
import 'systems/particle_system.dart';
import 'systems/save_system.dart';
import 'utils/constants.dart';

class EpicGame extends Forge2DGame {
  EpicGame() : super(gravity: Vector2(0, GameConstants.gravity));

  late Player player;
  late ParticleSystem particles;
  late ParallaxBackground background;
  final CameraShake cameraShake = CameraShake();
  final AchievementSystem achievements = AchievementSystem();
  final math.Random _rng = math.Random();

  int health = GameConstants.maxHealth;
  int maxHealth = GameConstants.maxHealth;
  int score = 0;
  int coinsCollected = 0;
  int enemiesKilled = 0;
  int level = 1;
  bool isPlaying = false;
  bool isPaused = false;
  double _autoSaveTimer = 0;

  final List<Achievement> _pendingPopups = [];

  @override
  Future<void> onLoad() async {
    // الخلفية
    background = ParallaxBackground();
    await add(background);

    // الأرضية الرئيسية
    await add(Ground(Vector2(0, 8), Vector2(80, 1)));

    // منصات متنوعة
    await add(Ground(Vector2(-14, 2), Vector2(6, 0.5)));
    await add(Ground(Vector2(14, -2), Vector2(6, 0.5)));
    await add(Ground(Vector2(0, -6), Vector2(5, 0.5)));
    await add(Ground(Vector2(-25, -2), Vector2(4, 0.5)));
    await add(Ground(Vector2(25, 2), Vector2(4, 0.5)));
    await add(Ground(Vector2(-32, -6), Vector2(3, 0.5)));
    await add(Ground(Vector2(32, -6), Vector2(3, 0.5)));

    // أعداء بسيطون
    await add(BaseEnemy(Vector2(-18, 6)));
    await add(BaseEnemy(Vector2(18, -5)));

    // أعداء مطاردون
    await add(ChaserEnemy(Vector2(-28, 6)));
    await add(ChaserEnemy(Vector2(28, -5)));

    // الزعيم
    await add(BossEnemy(Vector2(0, -12)));

    // العملات
    for (int i = -20; i <= 20; i += 4) {
      await add(Coin(Vector2(i.toDouble(), 5.5)));
    }
    for (int i = -30; i <= 30; i += 6) {
      await add(Coin(Vector2(i.toDouble(), -9.5)));
    }

    // قوارير الصحة
    await add(HealthPotion(Vector2(-15, 4.5)));
    await add(HealthPotion(Vector2(15, -4.5)));

    // اللاعب
    player = Player(Vector2(0, 6));
    await add(player);

    // الجزيئات
    particles = ParticleSystem();
    await add(particles);

    // الكاميرا
    camera.follow(player);
    camera.zoom = GameConstants.cameraZoom;

    overlays.add('mainMenu');
  }

  void startGame() {
    isPlaying = true;
    overlays.remove('mainMenu');
    overlays.add('hud');
  }

  void pauseGame() {
    if (isPaused) return;
    isPaused = true;
    pauseEngine();
    overlays.add('pauseMenu');
  }

  void resumeGame() {
    if (!isPaused) return;
    isPaused = false;
    overlays.remove('pauseMenu');
    resumeEngine();
  }

  void returnToMenu() {
    isPaused = false;
    isPlaying = false;
    overlays.remove('pauseMenu');
    overlays.remove('hud');
    overlays.add('mainMenu');
    resumeEngine();
  }

  void movePlayer(double x) => player.setHorizontal(x);
  void jumpPlayer() => player.jump();

  void dashPlayer() {
    player.dash();
    particles.spawnBurst(
      player.body.position.clone(),
      count: 10,
      color: const Color(0xFF4FC3F7),
      speed: 100,
    );
    add(DashTrail(player.body.position.clone()));
  }

  void attackPlayer() {
    player.attack();
    final dir = player.isFacingRight ? 1.0 : -1.0;
    final attackPos = player.body.position + Vector2(dir * 1.0, 0);

    // تأثير بصري
    add(HitEffect(attackPos));
    particles.spawnBurst(
      attackPos,
      count: 8,
      color: const Color(0xFFFFD700),
      speed: 130,
    );

    // إلحاق ضرر بالأعداء القريبين
    for (final child in children.whereType<BaseEnemy>()) {
      if ((child.body.position - attackPos).length < 1.3) {
        final dmg = 20 + _rng.nextInt(15);
        final isCrit = _rng.nextDouble() < 0.2;
        final finalDmg = isCrit ? dmg * 2 : dmg;
        child.takeDamage(finalDmg);
        add(DamageNumber(
          child.body.position.clone(),
          finalDmg,
          isCrit: isCrit,
        ));
        cameraShake.shake(intensity: isCrit ? 0.8 : 0.4, duration: 0.25);
        particles.spawnBurst(
          child.body.position.clone(),
          count: 12,
          color: const Color(0xFFE53935),
        );
        if (child.health <= 0) _onEnemyKilled();
      }
    }

    for (final child in children.whereType<ChaserEnemy>()) {
      if ((child.body.position - attackPos).length < 1.3) {
        final dmg = 20 + _rng.nextInt(15);
        child.takeDamage(dmg);
        add(DamageNumber(child.body.position.clone(), dmg));
        cameraShake.shake(intensity: 0.4, duration: 0.2);
        if (child.health <= 0) _onEnemyKilled();
      }
    }

    for (final child in children.whereType<BossEnemy>()) {
      if ((child.body.position - attackPos).length < 2.2) {
        final dmg = 20 + _rng.nextInt(15);
        child.takeDamage(dmg);
        add(DamageNumber(child.body.position.clone(), dmg));
        cameraShake.shake(intensity: 0.6, duration: 0.3);
      }
    }
  }

  void _onEnemyKilled() {
    enemiesKilled++;
    score += 50;
    final unlocked = achievements.register('first_blood', 1);
    if (unlocked != null) _pendingPopups.add(unlocked);
    achievements.register('hunter', 1);
    achievements.register('slayer', 1);
  }

  void collectCoin(Vector2 pos) {
    coinsCollected++;
    score += 10;
    particles.spawnBurst(
      pos,
      count: 6,
      color: GameConstants.goldColor,
      speed: 80,
    );
    achievements.register('collector', 1);
    achievements.register('treasure', 1);
  }

  void healPlayer(int amount) {
    health = (health + amount).clamp(0, maxHealth);
    particles.spawnBurst(
      player.body.position.clone(),
      count: 15,
      color: const Color(0xFF4CAF50),
      speed: 120,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    cameraShake.update(dt);
    if (cameraShake.isActive) {
      camera.viewfinder.position =
          player.body.position + cameraShake.offset;
    }

    // فحص العملات
    if (isPlaying) {
      for (final coin in children.whereType<Coin>()) {
        if (coin.collected) continue;
        if ((coin.body.position - player.body.position).length < 0.8) {
          coin.collected = true;
          collectCoin(coin.body.position);
          coin.removeFromParent();
        }
      }

      for (final potion in children.whereType<HealthPotion>()) {
        if ((potion.body.position - player.body.position).length < 0.8) {
          healPlayer(30);
          potion.removeFromParent();
        }
      }

      // ضرر من الأعداء
      for (final enemy in children.whereType<BaseEnemy>()) {
        if ((enemy.body.position - player.body.position).length < 1.0) {
          health = (health - 1).clamp(0, maxHealth);
        }
      }
      for (final enemy in children.whereType<ChaserEnemy>()) {
        if ((enemy.body.position - player.body.position).length < 1.0) {
          health = (health - 2).clamp(0, maxHealth);
        }
      }
      for (final enemy in children.whereType<BossEnemy>()) {
        if ((enemy.body.position - player.body.position).length < 2.0) {
          health = (health - 3).clamp(0, maxHealth);
        }
      }

      // الحفظ التلقائي كل 10 ثواني
      _autoSaveTimer += dt;
      if (_autoSaveTimer >= 10) {
        _autoSaveTimer = 0;
        SaveSystem.save(
          level: level,
          score: score,
          health: health,
          inventory: const [],
        );
      }
    }
  }

  Achievement? popAchievement() {
    if (_pendingPopups.isEmpty) return null;
    return _pendingPopups.removeAt(0);
  }

  bool get hasPopup => _pendingPopups.isNotEmpty;
}
