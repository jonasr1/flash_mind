class UserProgress {
  final int currentXP;

  const UserProgress({required this.currentXP});

  int get level => (currentXP ~/ 100) + 1;

  int get maxXP => level * 100;

  int get currentLevelXP => currentXP % 100;

  double get progress => currentLevelXP / 100;

  String get title {
    if (level >= 10) return 'Mestre';
    if (level >= 7) return 'Especialista';
    if (level >= 4) return 'Explorador';

    return 'Iniciante';
  }
}
