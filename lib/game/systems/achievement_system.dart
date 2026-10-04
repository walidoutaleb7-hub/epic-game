class Achievement {
  final String id;
  final String title;
  final String description;
  final int target;
  int progress = 0;
  bool unlocked = false;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
  });
}

class AchievementSystem {
  final List<Achievement> _achievements = [
    Achievement(
      id: 'first_blood',
      title: 'الدم الأول',
      description: 'اقتل عدوك الأول',
      target: 1,
    ),
    Achievement(
      id: 'hunter',
      title: 'صياد ماهر',
      description: 'اقتل 10 أعداء',
      target: 10,
    ),
    Achievement(
      id: 'slayer',
      title: 'سفّاح',
      description: 'اقتل 50 عدو',
      target: 50,
    ),
    Achievement(
      id: 'collector',
      title: 'جامع',
      description: 'اجمع 100 عملة',
      target: 100,
    ),
    Achievement(
      id: 'treasure',
      title: 'كنز',
      description: 'اجمع 500 عملة',
      target: 500,
    ),
    Achievement(
      id: 'boss_killer',
      title: 'قاهر الزعماء',
      description: 'اهزم زعيمًا',
      target: 1,
    ),
    Achievement(
      id: 'explorer',
      title: 'مستكشف',
      description: 'وصل لمستوى 5',
      target: 5,
    ),
  ];

  List<Achievement> get all => _achievements;

  Achievement? register(String id, int increment) {
    final a = _achievements.where((x) => x.id == id).firstOrNull;
    if (a == null || a.unlocked) return null;
    a.progress += increment;
    if (a.progress >= a.target) {
      a.unlocked = true;
      return a;
    }
    return null;
  }
}
