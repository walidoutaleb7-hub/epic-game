import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

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
import 'systems/achievement_system.dart';
import 'systems/camera_shake.dart';
import 'systems/dialogue_system.dart';
import 'systems/level_manager.dart';
import 'systems/particle_system.dart';
import 'systems/save_system.dart';
import 'utils/constants.dart';

class EmberfallGame extends FlameGame {
  late Player player;
  late ParticleSystem particles;
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

  final List<Ground> _grounds = [];

  @override
  Color backgroundColor() => const Color(0xFF0A0E27);

  @override
  Future<void> onLoad() async {
    await _buildLevel();
    overlays.add('mainMenu');
  }

  Future<void> _buildLevel() async {
    children.whereType<Ground>().toList().forEach((c) => c.removeFromParent());
    children.whereType<HookAnchor>().toList().forEach((c) => c.removeFromParent());
    children.whereType<Coin>().toList().forEach((c) => c.removeFromParent());
    children.whereType<HealthPotion>().toList().forEach((c) => c.removeFromParent());
    children.whereType<BaseEnemy>().toList().forEach((c) => c.removeFromParent());
    children.whereType<ChaserEnemy>().toList().forEach((c) => c.removeFromParent());
    children.whereType<BossEnemy>().toList().forEach((c) => c.removeFromParent());
    children.whereType<ParallaxBackground>().toList().forEach((c) => c.removeFromParent());
    _grounds.clear();

    final data = levels.currentData;

    await add(ParallaxBackground());

    for (int i = 0; i < data.groundPositions.length; i++) {
      final p = data.groundPositions[i];
      final s = data.groundSizes[i];
      final g = Ground(Vector2(p[0], p[1]), Vector2(s[0], s[1]));
      await add(g);
      _grounds.add(g);
    }

    // حيطان
    final wl = Ground(Vector2(-400 * 30, 0), Vector2(20, 500));
    final wr = Ground(Vector2(400 * 30, 0), Vector2(20, 500));
    await add(wl);
    await add(wr);
    _grounds.add(wl);
    _grounds.add(wr);

    for (final a in data.hookAnchors) {
      await add(HookAnchor(Vector2(a[0], a[1])));
    }
    for (final c in data.coins) {
      await add(Coin(Vector2(c[0], c[1])));
    }
    for (final spawn in data.enemies) {
      final pos = Vector2(spawn.x, spawn.y);
      if (spawn.type == 'base') await add(BaseEnemy(pos));
      else if (spawn.type == 'chaser') await add(ChaserEnemy(pos));
      else if (spawn.type == 'boss') await add(BossEnemy(pos));
    }

    await add(HealthPotion(Vector2(-15 * 30, 4.5 * 30)));
    await add(HealthPotion(Vector2(15 * 30, -4.5 * 30)));

    player = Player(Vector2(data.playerStart[0], data.playerStart[1]));
    await add(player);

    particles = ParticleSystem();
    await add(particles);

    camera.follow(player);
    camera.viewfinder.zoom = 1.0;
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
    isPlaying = true;
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
    isPlaying = true;
  }

  void _showVictory() {
    isPlaying = false;
    overlays.remove('hud');
    overlays.add('victory');
  }

  void _triggerGameOver() {
    if (_dying) return;
    _dying = true;
    isPlaying = false;
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
    overlays.add('pauseMenu');
  }

  void resumeGame() {
    if (!isPaused) return;
    isPaused = false;
    overlays.remove('pauseMenu');
  }

  void returnToMenu() {
    isPaused = false;
    isPlaying = false;
    overlays.remove('pauseMenu');
    overlays.remove('hud');
    overlays.remove('gameOver');
    overlays.remove('victory');
    overlays.add('mainMenu');
  }

  void movePlayer(double x) => player.setHorizontal(x);
  void jumpPlayer() => player.jump();

  void dashPlayer() {
    player.dash();
    particles.spawnBurst(player.position.clone(), count: 10,
        color: const Color(0xFF4FC3F7), speed: 200);
    add(DashTrail(player.position.clone()));
  }

  void hookPlayer() {
    if (player.isHooking) {
      player.releaseHook();
      return;
    }
    HookAnchor? nearest;
    double minDist = 500;
    for (final anchor in children.whereType<HookAnchor>()) {
      final d = (anchor.position - player.position).length;
      if (d < minDist) {
        minDist = d;
        nearest = anchor;
      }
    }
    if (nearest != null) {
      player.startHook(nearest.position.clone());
      particles.spawnBurst(player.position.clone(), count: 8,
          color: const Color(0xFFFFD700), speed: 150);
    }
  }

  void fireProjectile() {
    if (_projectileCooldown > 0) return;
    _projectileCooldown = 0.35;
    final dir = Vector2(player.isFacingRight ? 1 : -1, 0);
    add(Projectile(player.position.clone(), dir));
  }

  void attackPlayer() {
    player.attack();
    final dir = player.isFacingRight ? 1.0 : -1.0;
    final attackPos = player.position + Vector2(dir * 50, 0);
    add(HitEffect(attackPos));
    particles.spawnBurst(attackPos, count: 8,
        color: const Color(0xFFFFD700), speed: 200);
    _damageEnemiesNear(attackPos, 80, 130, 20, 15);
  }

  void _damageEnemiesNear(Vector2 pos, double r1, double r2, int baseDmg, int variance) {
    for (final e in children.whereType<BaseEnemy>()) {
      if ((e.position - pos).length < r1) {
        final dmg = baseDmg + _rng.nextInt(variance);
        final isCrit = _rng.nextDouble() < 0.2;
        final fd = isCrit ? dmg * 2 : dmg;
        e.takeDamage(fd);
        add(DamageNumber(e.position.clone(), fd, isCrit: isCrit));
        cameraShake.shake(intensity: isCrit ? 8 : 4, duration: 0.25);
        if (e.health <= 0) _onEnemyKilled();
      }
    }
    for (final e in children.whereType<ChaserEnemy>()) {
      if ((e.position - pos).length < r1) {
        final dmg = baseDmg + _rng.nextInt(variance);
        e.takeDamage(dmg);
        add(DamageNumber(e.position.clone(), dmg));
        if (e.health <= 0) _onEnemyKilled();
      }
    }
    for (final e in children.whereType<BossEnemy>()) {
      if ((e.position - pos).length < r2) {
        final dmg = baseDmg + _rng.nextInt(variance);
        e.takeDamage(dmg);
        add(DamageNumber(e.position.clone(), dmg));
        cameraShake.shake(intensity: 6, duration: 0.3);
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
    particles.spawnBurst(pos, count: 6, color: GameConstants.goldColor, speed: 150);
    achievements.register('collector', 1);
    achievements.register('treasure', 1);
  }

  void healPlayer(int amount) {
    health = (health + amount).clamp(0, maxHealth);
    particles.spawnBurst(player.position.clone(), count: 15,
        color: const Color(0xFF4CAF50), speed: 200);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_projectileCooldown > 0) _projectileCooldown -= dt;

    cameraShake.update(dt);
    if (cameraShake.isActive) {
      camera.viewfinder.position = player.position + cameraShake.offset;
    }

    if (!isPlaying) return;
    if (health <= 0 && !_dying) {
      _triggerGameOver();
      return;
    }

    // التصادم مع الأرضيات
    bool grounded = false;
    for (final g in _grounds) {
      if (player.rect.overlaps(g.rect)) {
        final pRect = player.rect;
        final gRect = g.rect;
        final overlapTop = pRect.bottom - gRect.top;
        final overlapBottom = gRect.bottom - pRect.top;
        final overlapLeft = pRect.right - gRect.left;
        final overlapRight = gRect.right - pRect.left;
        final minOverlap = [
          overlapTop, overlapBottom, overlapLeft, overlapRight
        ].reduce((a, b) => a < b ? a : b);

        if (minOverlap == overlapTop) {
          player.position.y = gRect.top - player.size.y / 2;
          player.velocity.y = 0;
          grounded = true;
        } else if (minOverlap == overlapBottom) {
          player.position.y = gRect.bottom + player.size.y / 2;
          player.velocity.y = 0;
        } else if (minOverlap == overlapLeft) {
          player.position.x = gRect.left - player.size.x / 2;
          player.velocity.x = 0;
        } else if (minOverlap == overlapRight) {
          player.position.x = gRect.right + player.size.x / 2;
          player.velocity.x = 0;
        }
      }
    }
    player.setGrounded(grounded);

    // عملات
    for (final coin in children.whereType<Coin>().toList()) {
      if (coin.collected) continue;
      if ((coin.position - player.position).length < 35) {
        coin.collected = true;
        collectCoin(coin.position.clone());
        coin.removeFromParent();
      }
    }

    // قوارير
    for (final potion in children.whereType<HealthPotion>().toList()) {
      if ((potion.position - player.position).length < 40) {
        healPlayer(30);
        potion.removeFromParent();
      }
    }

    // ضرر
    for (final e in children.whereType<BaseEnemy>()) {
      if ((e.position - player.position).length < 40) {
        health = (health - 1).clamp(0, maxHealth);
      }
    }
    for (final e in children.whereType<ChaserEnemy>()) {
      if ((e.position - player.position).length < 45) {
        health = (health - 2).clamp(0, maxHealth);
      }
    }
    for (final e in children.whereType<BossEnemy>()) {
      if ((e.position - player.position).length < 100) {
        health = (health - 3).clamp(0, maxHealth);
      }
    }

    // قذائف
    for (final proj in children.whereType<Projectile>().toList()) {
      for (final e in children.whereType<BaseEnemy>()) {
        if ((proj.position - e.position).length < 35) {
          e.takeDamage(30);
          add(DamageNumber(e.position.clone(), 30));
          proj.removeFromParent();
          if (e.health <= 0) _onEnemyKilled();
          break;
        }
      }
    }

    for (final anchor in children.whereType<HookAnchor>()) {
      anchor.isInRange = (anchor.position - player.position).length < 400;
    }

    _autoSaveTimer += dt;
    if (_autoSaveTimer >= 10) {
      _autoSaveTimer = 0;
      SaveSystem.save(level: levels.currentLevel, score: score, health: health, inventory: const []);
    }
  }

  PlayerState get playerState => player.state;
  String get currentHint => _currentHint;
}
