import 'dart:ui';
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
import 'components/levels/hook_anchor.dart';
import 'components/levels/parallax_background.dart';
import 'components/player/player.dart';
import 'components/player/player_state.dart';
import 'components/player/projectile.dart';
import 'data/level_data.dart';
import 'systems/achievement_system.dart';
import 'systems/camera_shake.dart';
import 'systems/dialogue_system.dart';
import 'systems/level_manager.dart';
import 'systems/particle_system.dart' as ps;
import 'systems/save_system.dart';
import 'utils/constants.dart';

class EpicGame extends Forge2DGame {
  EpicGame() : super(gravity: Vector2(0, GameConstants.gravity));

  late Player player;
  late ps.ParticleSystem particles;
  late ParallaxBackground background;
  final CameraShake cameraShake = CameraShake();
  final AchievementSystem achievements = AchievementSystem();
  final DialogueSystem dialogue = DialogueSystem();
  final LevelManager levels = LevelManager();
  final math.Random _rng = math.Random();

  int health = GameConstants.maxHealth;
  int maxHealth = GameConstants.maxHealth;
  int score = 0;
  int coinsCollected = 0;
  int enemiesKilled = 0;
  bool isPlaying = false;
  bool isPaused = false;
  bool _introShown = false;
  bool _dying = false;
  double _autoSaveTimer = 0;
  double _projectileCooldown = 0;
  String _currentHint = '';

  List<Component> _levelComponents = [];

  @override
  Future<void> onLoad() async {
    await _buildLevel();
    camera.follow(player);
    camera.viewfinder.zoom = GameConstants.cameraZoom;
    overlays.add('mainMenu');
  }

  Future<void> _buildLevel() async {
    // تنظيف المستوى القديم
    for (final c in _levelComponents) {
      c.removeFromParent();
    }
    _levelComponents.clear();

    final data = levels.currentData;

    background = ParallaxBackground();
    await add(background);
    _levelComponents.add(background);

    // الأرضيات
    for (int i = 0; i < data.groundPositions.length; i++) {
      final g = Ground(data.groundPositions[i], data.groundSizes[i]);
      await add(g);
      _levelComponents.add(g);
    }

    // حيطان جانبية
    final wallLeft = Ground(Vector2(-40, 0), Vector2(1, 24));
    final wallRight = Ground(Vector2(40, 0), Vector2(1, 24));
    await add(wallLeft);
    await add(wallRight);
    _levelComponents.add(wallLeft);
    _levelComponents.add(wallRight);

    // نقاط الخطاف
    for (final anchor in data.hookAnchors) {
      final a = HookAnchor(anchor);
      await add(a);
      _levelComponents.add(a);
    }

    // العملات
    for (final coin in data.coins) {
      final c = Coin(coin);
      await add(c);
      _levelComponents.add(c);
    }

    // الأعداء
    for (final spawn in data.enemies) {
      if (spawn.type == 'base') {
        final e = BaseEnemy(spawn.position);
        await add(e);
        _levelComponents.add(e);
      } else if (spawn.type == 'chaser') {
        final e = ChaserEnemy(spawn.position);
        await add(e);
        _levelComponents.add(e);
      } else if (spawn.type == 'boss') {
        final e = BossEnemy(spawn.position);
        await add(e);
        _levelComponents.add(e);
      }
    }

    // قوارير صحة
    final p1 = HealthPotion(Vector2(-15, 4.5));
    final p2 = HealthPotion(Vector2(15, -4.5));
    await add(p1);
    await add(p2);
    _levelComponents.add(p1);
    _levelComponents.add(p2);

    // اللاعب
    player = Player(data.playerStart);
    await add(player);
    _levelComponents.add(player);

    // الجزيئات
    particles = ps.ParticleSystem();
    await add(particles);
    _levelComponents.add(particles);

    camera.follow(player);
  }

  void startGame() {
    isPlaying = true;
    _dying = false;
    overlays.remove('mainMenu');
    overlays.remove('gameOver');
    overlays.remove('victory');

    if (!_introShown) {
      _introShown = true;
      overlays.add('dialogue');
      Future.delayed(const Duration(seconds: 8), () {
        if (!isPlaying) return;
        overlays.remove('dialogue');
        overlays.add('hud');
        _showHint('استعمل العصا للحركة، وزر القفز للأعلى');
      });
    } else {
      overlays.add('hud');
    }
  }

  void _showHint(String hint) {
    _currentHint = hint;
    overlays.add('hint');
    Future.delayed(const Duration(seconds: 4), () {
      overlays.remove('hint');
    });
  }

  void retryLevel() {
    health = maxHealth;
    _dying = false;
    score = 0;
    coinsCollected = 0;
    enemiesKilled = 0;
    levels.reset();
    _buildLevel();
    overlays.remove('gameOver');
    overlays.add('hud');
    resumeEngine();
  }

  void nextLevel() {
    if (!levels.advanceLevel()) {
      _showVictory();
      return;
    }
    health = maxHealth;
    _dying = false;
    _buildLevel();
    overlays.remove('victory');
    overlays.add('hud');
    resumeEngine();
  }

  void _showVictory() {
    isPlaying = false;
    pauseEngine();
    overlays.remove('hud');
    overlays.add('victory');
  }

  void _triggerGameOver() {
    if (_dying) return;
    _dying = true;
    isPlaying = false;
    pauseEngine();
    overlays.remove('hud');
    overlays.add('gameOver');
    SaveSystem.clear();
  }

  void openSettings() => overlays.add('settings');
  void closeSettings() => overlays.remove('settings');
  void openAchievements() => overlays.add('achievements');
  void closeAchievements() => overlays.remove('achievements');

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
    overlays.remove('gameOver');
    overlays.remove('victory');
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

  void hookPlayer() {
    if (player.isHooking) {
      player.releaseHook();
      return;
    }
    HookAnchor? nearest;
    double minDist = 12.0;
    for (final anchor in children.whereType<HookAnchor>()) {
      final d = (anchor.body.position - player.body.position).length;
      if (d < minDist) {
        minDist = d;
        nearest = anchor;
      }
    }
    if (nearest != null) {
      player.startHook(nearest.body.position.clone());
      particles.spawnBurst(
        player.body.position.clone(),
        count: 8,
        color: const Color(0xFFFFD700),
        speed: 80,
      );
    }
  }

  void fireProjectile() {
    if (_projectileCooldown > 0) return;
    _projectileCooldown = 0.35;
    final dir = Vector2(player.isFacingRight ? 1 : -1, 0);
    final spawnPos = player.body.position + dir * 0.8;
    add(Projectile(spawnPos, dir));
    particles.spawnBurst(
      spawnPos,
      count: 5,
      color: const Color(0xFFFFD700),
      speed: 60,
    );
  }

  void attackPlayer() {
    player.attack();
    final dir = player.isFacingRight ? 1.0 : -1.0;
    final attackPos = player.body.position + Vector2(dir * 1.0, 0);
    add(HitEffect(attackPos));
    particles.spawnBurst(
      attackPos,
      count: 8,
      color: const Color(0xFFFFD700),
      speed: 130,
    );
    _damageEnemiesNear(attackPos, 1.3, 2.2, 20, 15);
  }

  void _damageEnemiesNear(
    Vector2 pos,
    double range1,
    double range2,
    int baseDmg,
    int variance,
  ) {
    for (final child in children.whereType<BaseEnemy>()) {
      if ((child.body.position - pos).length < range1) {
        final dmg = baseDmg + _rng.nextInt(variance);
        final isCrit = _rng.nextDouble() < 0.2;
        final finalDmg = isCrit ? dmg * 2 : dmg;
        child.takeDamage(finalDmg);
        add(DamageNumber(child.body.position.clone(), finalDmg, isCrit: isCrit));
        cameraShake.shake(intensity: isCrit ? 0.8 : 0.4, duration: 0.25);
        if (child.health <= 0) _onEnemyKilled();
      }
    }
    for (final child in children.whereType<ChaserEnemy>()) {
      if ((child.body.position - pos).length < range1) {
        final dmg = baseDmg + _rng.nextInt(variance);
        child.takeDamage(dmg);
        add(DamageNumber(child.body.position.clone(), dmg));
        if (child.health <= 0) _onEnemyKilled();
      }
    }
    for (final child in children.whereType<BossEnemy>()) {
      if ((child.body.position - pos).length < range2) {
        final dmg = baseDmg + _rng.nextInt(variance);
        child.takeDamage(dmg);
        add(DamageNumber(child.body.position.clone(), dmg));
        cameraShake.shake(intensity: 0.6, duration: 0.3);
      }
    }
  }

  void _onEnemyKilled() {
    enemiesKilled++;
    score += 50;
    levels.registerKill();
    achievements.register('first_blood', 1);
    achievements.register('hunter', 1);
    achievements.register('slayer', 1);

    // فحص الإنجاز
    if (levels.canAdvance && !_dying) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (isPlaying) _showVictory();
      });
    }
  }

  void collectCoin(Vector2 pos) {
    coinsCollected++;
    score += 10;
    levels.registerCoin();
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
    if (_projectileCooldown > 0) _projectileCooldown -= dt;

    cameraShake.update(dt);
    if (cameraShake.isActive) {
      camera.viewfinder.position = player.body.position + cameraShake.offset;
    }

    if (!isPlaying) return;

    // فحص الموت
    if (health <= 0 && !_dying) {
      _triggerGameOver();
      return;
    }

    for (final coin in children.whereType<Coin>().toList()) {
      if (coin.collected) continue;
      if ((coin.body.position - player.body.position).length < 0.8) {
        coin.collected = true;
        collectCoin(coin.body.position);
        coin.removeFromParent();
      }
    }

    for (final potion in children.whereType<HealthPotion>().toList()) {
      if ((potion.body.position - player.body.position).length < 0.8) {
        healPlayer(30);
        potion.removeFromParent();
      }
    }

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

    for (final proj in children.whereType<Projectile>().toList()) {
      for (final enemy in children.whereType<BaseEnemy>()) {
        if ((proj.body.position - enemy.body.position).length < 0.6) {
          enemy.takeDamage(30);
          add(DamageNumber(enemy.body.position.clone(), 30));
          proj.removeFromParent();
          if (enemy.health <= 0) _onEnemyKilled();
          break;
        }
      }
    }

    for (final anchor in children.whereType<HookAnchor>()) {
      anchor.isInRange =
          (anchor.body.position - player.body.position).length < 12.0;
    }

    _autoSaveTimer += dt;
    if (_autoSaveTimer >= 10) {
      _autoSaveTimer = 0;
      SaveSystem.save(
        level: levels.currentLevel,
        score: score,
        health: health,
        inventory: const [],
      );
    }
  }

  PlayerState get playerState => player.state;
  String get currentHint => _currentHint;
}
