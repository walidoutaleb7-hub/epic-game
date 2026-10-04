import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'components/levels/ground.dart';
import 'components/player/player.dart';

class EpicGame extends Forge2DGame {
  EpicGame() : super(gravity: Vector2(0, 25));

  late Player player;
  int health = 100;
  int maxHealth = 100;
  int score = 0;
  bool isPlaying = false;

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

    // اللاعب
    player = Player(Vector2(0, 6));
    await add(player);

    // الكاميرا
    camera.follow(player);
    camera.zoom = 50;

    // القائمة الرئيسية
    overlays.add('mainMenu');
  }

  void startGame() {
    isPlaying = true;
    overlays.remove('mainMenu');
    overlays.add('hud');
  }

  void pauseGame() {
    isPlaying = false;
    pauseEngine();
  }

  void movePlayer(double x) => player.setHorizontal(x);
  void jumpPlayer() => player.jump();
  void dashPlayer() => player.dash();
  void attackPlayer() => player.attack();
}
