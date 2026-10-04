import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'components/enemies/base_enemy.dart';
import 'components/items/coin.dart';
import 'components/levels/ground.dart';
import 'components/player/player.dart';
import 'utils/constants.dart';

class EpicGame extends Forge2DGame {
  EpicGame() : super(gravity: Vector2(0, GameConstants.gravity));

  late Player player;
  int health = 100;
  int maxHealth = 100;
  int score = 0;
  bool isPlaying = false;
  bool isPaused = false;

  @override
  Future<void> onLoad() async {
    // الأرضية الرئيسية
    await add(Ground(Vector2(0, 8), Vector2(80, 1)));

    // منصات
    await add(Ground(Vector2(-14, 2), Vector2(6, 0.5)));
    await add(Ground(Vector2(14, -2), Vector2(6, 0.5)));
    await add(Ground(Vector2(0, -6), Vector2(5, 0.5)));
    await add(Ground(Vector2(-25, -2), Vector2(4, 0.5)));
    await add(Ground(Vector2(25, 2), Vector2(4, 0.5)));

    // أعداء
    await add(BaseEnemy(Vector2(-18, 6)));
    await add(BaseEnemy(Vector2(18, -5)));
    await add(BaseEnemy(Vector2(0, -4)));

    // عملات
    for (int i = -20; i <= 20; i += 4) {
      await add(Coin(Vector2(i.toDouble(), 5.5)));
    }

    // اللاعب
    player = Player(Vector2(0, 6));
    await add(player);

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
  void dashPlayer() => player.dash();
  void attackPlayer() => player.attack();

  @override
  void update(double dt) {
    super.update(dt);
    if (isPlaying) score += 0;
  }
}
