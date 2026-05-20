class UserProgress {
  final int totalXp;
  final int streakDays;
  final DateTime? lastStudyDate;

  const UserProgress({
    required this.totalXp,
    required this.streakDays,
    required this.lastStudyDate,
  });

  int get level => (totalXp ~/ 100) + 1;

  int get currentLevelXp => totalXp % 100;

  int get xpForNextLevel => 100 - currentLevelXp;

  double get levelProgress => currentLevelXp / 100;

  // Backwards-compatible alias for UI widgets.
  double get progress => levelProgress;

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

  UserProgress copyWith({
    int? totalXp,
    int? streakDays,
    DateTime? lastStudyDate,
  }) {
    return UserProgress(
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
    );
  }
}
