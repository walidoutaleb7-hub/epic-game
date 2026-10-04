import 'package:flame/components.dart';

class EnemySpawn {
  final Vector2 position;
  final String type; // 'base', 'chaser', 'boss'
  EnemySpawn(this.position, this.type);
}

class LevelData {
  final int id;
  final String name;
  final String biome;
  final Vector2 playerStart;
  final List<Vector2> groundPositions;
  final List<Vector2> groundSizes;
  final List<Vector2> hookAnchors;
  final List<Vector2> coins;
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
    // المستوى 1 - الغابة
    LevelData(
      id: 1,
      name: 'الغابة المظلمة',
      biome: 'forest',
      playerStart: Vector2(0, 6),
      groundPositions: [
        Vector2(0, 8),
        Vector2(-14, 2),
        Vector2(14, -2),
        Vector2(0, -6),
        Vector2(-25, -2),
        Vector2(25, 2),
      ],
      groundSizes: [
        Vector2(80, 1),
        Vector2(6, 0.5),
        Vector2(6, 0.5),
        Vector2(5, 0.5),
        Vector2(4, 0.5),
        Vector2(4, 0.5),
      ],
      hookAnchors: [
        Vector2(-6, -3),
        Vector2(6, -3),
        Vector2(0, -12),
      ],
      coins: [
        Vector2(-20, 5.5),
        Vector2(-16, 5.5),
        Vector2(-12, 5.5),
        Vector2(-8, 5.5),
        Vector2(-4, 5.5),
        Vector2(0, 5.5),
        Vector2(4, 5.5),
        Vector2(8, 5.5),
        Vector2(12, 5.5),
        Vector2(16, 5.5),
        Vector2(20, 5.5),
      ],
      enemies: [
        EnemySpawn(Vector2(-18, 6), 'base'),
        EnemySpawn(Vector2(18, -5), 'base'),
      ],
      targetKills: 2,
    ),

    // المستوى 2 - الكهوف
    LevelData(
      id: 2,
      name: 'كهوف الظلام',
      biome: 'cave',
      playerStart: Vector2(0, 6),
      groundPositions: [
        Vector2(0, 8),
        Vector2(-10, 2),
        Vector2(10, 2),
        Vector2(-18, -4),
        Vector2(18, -4),
        Vector2(0, -8),
        Vector2(-30, 0),
        Vector2(30, 0),
      ],
      groundSizes: [
        Vector2(80, 1),
        Vector2(5, 0.5),
        Vector2(5, 0.5),
        Vector2(5, 0.5),
        Vector2(5, 0.5),
        Vector2(6, 0.5),
        Vector2(4, 0.5),
        Vector2(4, 0.5),
      ],
      hookAnchors: [
        Vector2(-14, -2),
        Vector2(14, -2),
        Vector2(-5, -6),
        Vector2(5, -6),
        Vector2(0, -14),
      ],
      coins: [
        Vector2(-25, 5.5),
        Vector2(-20, 5.5),
        Vector2(-15, 5.5),
        Vector2(-10, 5.5),
        Vector2(-5, 5.5),
        Vector2(0, 5.5),
        Vector2(5, 5.5),
        Vector2(10, 5.5),
        Vector2(15, 5.5),
        Vector2(20, 5.5),
        Vector2(25, 5.5),
        Vector2(-18, -6),
        Vector2(18, -6),
      ],
      enemies: [
        EnemySpawn(Vector2(-20, 6), 'base'),
        EnemySpawn(Vector2(20, 6), 'chaser'),
        EnemySpawn(Vector2(0, -10), 'chaser'),
      ],
      targetKills: 3,
    ),

    // المستوى 3 - القلعة (Boss)
    LevelData(
      id: 3,
      name: 'قلعة الزعيم',
      biome: 'castle',
      playerStart: Vector2(0, 6),
      groundPositions: [
        Vector2(0, 8),
        Vector2(-15, 0),
        Vector2(15, 0),
        Vector2(0, -6),
        Vector2(-25, -6),
        Vector2(25, -6),
      ],
      groundSizes: [
        Vector2(80, 1),
        Vector2(6, 0.5),
        Vector2(6, 0.5),
        Vector2(8, 0.5),
        Vector2(4, 0.5),
        Vector2(4, 0.5),
      ],
      hookAnchors: [
        Vector2(-20, -2),
        Vector2(20, -2),
        Vector2(-8, -10),
        Vector2(8, -10),
      ],
      coins: [
        Vector2(-30, 5.5),
        Vector2(-25, 5.5),
        Vector2(-20, 5.5),
        Vector2(-15, 5.5),
        Vector2(-10, 5.5),
        Vector2(-5, 5.5),
        Vector2(0, 5.5),
        Vector2(5, 5.5),
        Vector2(10, 5.5),
        Vector2(15, 5.5),
        Vector2(20, 5.5),
        Vector2(25, 5.5),
        Vector2(30, 5.5),
      ],
      enemies: [
        EnemySpawn(Vector2(-15, -2), 'chaser'),
        EnemySpawn(Vector2(15, -2), 'chaser'),
        EnemySpawn(Vector2(0, -12), 'boss'),
      ],
      targetKills: 3,
    ),
  ];

  static LevelData getLevel(int id) {
    return levels.firstWhere((l) => l.id == id, orElse: () => levels.first);
  }
}
