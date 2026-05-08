class UserProgress {
  final int currentXP;

  const UserProgress({required this.currentXP});

  int get level => (currentXP ~/ 100) + 1;

  int get maxXP => level * 100;

  int get currentLevelXP => currentXP % 100;

  double get progress => currentLevelXP / 100;

  String get title {
    if (level >= 10) return 'Mestre';
    if (level >= 9) return 'Sábio';
    if (level >= 8) return 'Guardião';
    if (level >= 7) return 'Especialista';
    if (level >= 6) return 'Veterano';
    if (level >= 5) return 'Desbravador';
    if (level >= 4) return 'Explorador';
    if (level >= 3) return 'Praticante';
    if (level >= 2) return 'Aprendiz';
    return 'Iniciante';
  }
}
