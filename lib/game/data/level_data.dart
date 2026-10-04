import 'package:flame/components.dart';

class EnemySpawn {
  final double x;
  final double y;
  final String type; // 'base', 'chaser', 'boss'
  EnemySpawn(this.x, this.y, this.type);
}

class LevelData {
  final int id;
  final String name;
  final String biome;
  final List<double> playerStart; // [x, y]
  final List<List<double>> groundPositions;
  final List<List<double>> groundSizes;
  final List<List<double>> hookAnchors;
  final List<List<double>> coins;
  final List<EnemySpawn> enemies;
  final int targetKills;

  LevelData({
    required this.id,
    required this.name,
    required this.biome,
    required this.playerStart,
    required this.groundPositions,
    required this.groundSizes,
    required this.hookAnchors,
    required this.coins,
    required this.enemies,
    required this.targetKills,
  });
}

class LevelDatabase {
  static final List<LevelData> levels = [
    LevelData(
      id: 1,
      name: 'الغابة المظلمة',
      biome: 'forest',
      playerStart: [0, 6],
      groundPositions: [
        [0, 8], [-14, 2], [14, -2], [0, -6], [-25, -2], [25, 2],
      ],
      groundSizes: [
        [80, 1], [6, 0.5], [6, 0.5], [5, 0.5], [4, 0.5], [4, 0.5],
      ],
      hookAnchors: [
        [-6, -3], [6, -3], [0, -12],
      ],
      coins: [
        [-20, 5.5], [-16, 5.5], [-12, 5.5], [-8, 5.5], [-4, 5.5],
        [0, 5.5], [4, 5.5], [8, 5.5], [12, 5.5], [16, 5.5], [20, 5.5],
      ],
      enemies: [
        EnemySpawn(-18, 6, 'base'),
        EnemySpawn(18, -5, 'base'),
      ],
      targetKills: 2,
    ),
    LevelData(
      id: 2,
      name: 'كهوف الظلام',
      biome: 'cave',
      playerStart: [0, 6],
      groundPositions: [
        [0, 8], [-10, 2], [10, 2], [-18, -4], [18, -4], [0, -8],
        [-30, 0], [30, 0],
      ],
      groundSizes: [
        [80, 1], [5, 0.5], [5, 0.5], [5, 0.5], [5, 0.5], [6, 0.5],
        [4, 0.5], [4, 0.5],
      ],
      hookAnchors: [
        [-14, -2], [14, -2], [-5, -6], [5, -6], [0, -14],
      ],
      coins: [
        [-25, 5.5], [-20, 5.5], [-15, 5.5], [-10, 5.5], [-5, 5.5],
        [0, 5.5], [5, 5.5], [10, 5.5], [15, 5.5], [20, 5.5], [25, 5.5],
        [-18, -6], [18, -6],
      ],
      enemies: [
        EnemySpawn(-20, 6, 'base'),
        EnemySpawn(20, 6, 'chaser'),
        EnemySpawn(0, -10, 'chaser'),
      ],
      targetKills: 3,
    ),
    LevelData(
      id: 3,
      name: 'قلعة الزعيم',
      biome: 'castle',
      playerStart: [0, 6],
      groundPositions: [
        [0, 8], [-15, 0], [15, 0], [0, -6], [-25, -6], [25, -6],
      ],
      groundSizes: [
        [80, 1], [6, 0.5], [6, 0.5], [8, 0.5], [4, 0.5], [4, 0.5],
      ],
      hookAnchors: [
        [-20, -2], [20, -2], [-8, -10], [8, -10],
      ],
      coins: [
        [-30, 5.5], [-25, 5.5], [-20, 5.5], [-15, 5.5], [-10, 5.5],
        [-5, 5.5], [0, 5.5], [5, 5.5], [10, 5.5], [15, 5.5],
        [20, 5.5], [25, 5.5], [30, 5.5],
      ],
      enemies: [
        EnemySpawn(-15, -2, 'chaser'),
        EnemySpawn(15, -2, 'chaser'),
        EnemySpawn(0, -12, 'boss'),
      ],
      targetKills: 3,
    ),
  ];

  static LevelData getLevel(int id) {
    return levels.firstWhere((l) => l.id == id, orElse: () => levels.first);
  }
}
