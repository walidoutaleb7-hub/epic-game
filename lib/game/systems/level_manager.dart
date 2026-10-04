import '../data/level_data.dart';

class LevelManager {
  int _currentLevel = 1;
  int _totalLevels = LevelDatabase.levels.length;
  int _killsThisLevel = 0;
  int _coinsThisLevel = 0;

  int get currentLevel => _currentLevel;
  int get totalLevels => _totalLevels;
  int get killsThisLevel => _killsThisLevel;
  int get coinsThisLevel => _coinsThisLevel;

  LevelData get currentData => LevelDatabase.getLevel(_currentLevel);

  bool get isLastLevel => _currentLevel >= _totalLevels;

  void registerKill() => _killsThisLevel++;
  void registerCoin() => _coinsThisLevel++;

  bool get canAdvance {
    return _killsThisLevel >= currentData.targetKills;
  }

  bool advanceLevel() {
    if (!canAdvance || isLastLevel) return false;
    _currentLevel++;
    _killsThisLevel = 0;
    _coinsThisLevel = 0;
    return true;
  }

  void reset() {
    _currentLevel = 1;
    _killsThisLevel = 0;
    _coinsThisLevel = 0;
  }

  void setLevel(int id) {
    if (id < 1 || id > _totalLevels) return;
    _currentLevel = id;
    _killsThisLevel = 0;
    _coinsThisLevel = 0;
  }
}
