class EnemySpawn {
  final double x;
  final double y;
  final String type;
  EnemySpawn(this.x, this.y, this.type);
}

class LevelData {
  final int id;
  final String name;
  final String biome;
  final List<double> playerStart;
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
  // كل الإحداثيات مضروبة في 30 باش تكون مرئية
  static const double S = 30.0;

  static final List<LevelData> levels = [
    LevelData(
      id: 1,
      name: 'الغابة المظلمة',
      biome: 'forest',
      playerStart: [0, 6 * S],
      groundPositions: [
        [0, 8 * S], [-14 * S, 2 * S], [14 * S, -2 * S], [0, -6 * S],
        [-25 * S, -2 * S], [25 * S, 2 * S],
      ],
      groundSizes: [
        [80 * S, 1 * S], [6 * S, 0.5 * S], [6 * S, 0.5 * S],
        [5 * S, 0.5 * S], [4 * S, 0.5 * S], [4 * S, 0.5 * S],
      ],
      hookAnchors: [
        [-6 * S, -3 * S], [6 * S, -3 * S], [0, -12 * S],
      ],
      coins: [
        [-20 * S, 5.5 * S], [-16 * S, 5.5 * S], [-12 * S, 5.5 * S],
        [-8 * S, 5.5 * S], [-4 * S, 5.5 * S], [0, 5.5 * S],
        [4 * S, 5.5 * S], [8 * S, 5.5 * S], [12 * S, 5.5 * S],
        [16 * S, 5.5 * S], [20 * S, 5.5 * S],
      ],
      enemies: [
        EnemySpawn(-18 * S, 6 * S, 'base'),
        EnemySpawn(18 * S, -5 * S, 'base'),
      ],
      targetKills: 2,
    ),
    LevelData(
      id: 2,
      name: 'كهوف الظلام',
      biome: 'cave',
      playerStart: [0, 6 * S],
      groundPositions: [
        [0, 8 * S], [-10 * S, 2 * S], [10 * S, 2 * S],
        [-18 * S, -4 * S], [18 * S, -4 * S], [0, -8 * S],
        [-30 * S, 0], [30 * S, 0],
      ],
      groundSizes: [
        [80 * S, 1 * S], [5 * S, 0.5 * S], [5 * S, 0.5 * S],
        [5 * S, 0.5 * S], [5 * S, 0.5 * S], [6 * S, 0.5 * S],
        [4 * S, 0.5 * S], [4 * S, 0.5 * S],
      ],
      hookAnchors: [
        [-14 * S, -2 * S], [14 * S, -2 * S], [-5 * S, -6 * S],
        [5 * S, -6 * S], [0, -14 * S],
      ],
      coins: [
        [-25 * S, 5.5 * S], [-20 * S, 5.5 * S], [-15 * S, 5.5 * S],
        [-10 * S, 5.5 * S], [-5 * S, 5.5 * S], [0, 5.5 * S],
        [5 * S, 5.5 * S], [10 * S, 5.5 * S], [15 * S, 5.5 * S],
        [20 * S, 5.5 * S], [25 * S, 5.5 * S],
      ],
      enemies: [
        EnemySpawn(-20 * S, 6 * S, 'base'),
        EnemySpawn(20 * S, 6 * S, 'chaser'),
        EnemySpawn(0, -10 * S, 'chaser'),
      ],
      targetKills: 3,
    ),
    LevelData(
      id: 3,
      name: 'قلعة الزعيم',
      biome: 'castle',
      playerStart: [0, 6 * S],
      groundPositions: [
        [0, 8 * S], [-15 * S, 0], [15 * S, 0],
        [0, -6 * S], [-25 * S, -6 * S], [25 * S, -6 * S],
      ],
      groundSizes: [
        [80 * S, 1 * S], [6 * S, 0.5 * S], [6 * S, 0.5 * S],
        [8 * S, 0.5 * S], [4 * S, 0.5 * S], [4 * S, 0.5 * S],
      ],
      hookAnchors: [
        [-20 * S, -2 * S], [20 * S, -2 * S], [-8 * S, -10 * S],
        [8 * S, -10 * S],
      ],
      coins: [
        [-30 * S, 5.5 * S], [-25 * S, 5.5 * S], [-20 * S, 5.5 * S],
        [-15 * S, 5.5 * S], [-10 * S, 5.5 * S], [-5 * S, 5.5 * S],
        [0, 5.5 * S], [5 * S, 5.5 * S], [10 * S, 5.5 * S],
        [15 * S, 5.5 * S], [20 * S, 5.5 * S], [25 * S, 5.5 * S],
        [30 * S, 5.5 * S],
      ],
      enemies: [
        EnemySpawn(-15 * S, -2 * S, 'chaser'),
        EnemySpawn(15 * S, -2 * S, 'chaser'),
        EnemySpawn(0, -12 * S, 'boss'),
      ],
      targetKills: 3,
    ),
  ];

  static LevelData getLevel(int id) {
    return levels.firstWhere((l) => l.id == id, orElse: () => levels.first);
  }
}
