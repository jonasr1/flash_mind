class UserProgress {
  final int totalXp;
  final int streakDays;
  final DateTime? lastStudyDate;
  final int combo;
  final int bestStreak;
  final int totalStudyDays;
  final List<DateTime> studyDays;
  final int reviewsToday;

  const UserProgress({
    required this.totalXp,
    required this.streakDays,
    required this.lastStudyDate,
    this.combo = 0,
    this.bestStreak = 0,
    this.totalStudyDays = 0,
    this.studyDays = const [],
    this.reviewsToday = 0,
  });

  int get currentStreak => streakDays;

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'currentStreak': streakDays,
      'streakDays': streakDays,
      'lastStudyDate': lastStudyDate?.toIso8601String(),
      'combo': combo,
      'bestStreak': bestStreak,
      'totalStudyDays': totalStudyDays,
      'studyDays': studyDays.map((day) => day.toIso8601String()).toList(),
      'reviewsToday': reviewsToday,
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final studyDaysJson = json['studyDays'] as List<dynamic>? ?? [];

    return UserProgress(
      totalXp: json['totalXp'] ?? 0,
      streakDays: json['currentStreak'] ?? json['streakDays'] ?? 0,
      lastStudyDate: json['lastStudyDate'] != null
          ? DateTime.parse(json['lastStudyDate'])
          : null,
      combo: json['combo'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      totalStudyDays: json['totalStudyDays'] ?? studyDaysJson.length,
      studyDays: studyDaysJson
          .map((day) => DateTime.parse(day as String))
          .toList(),
      reviewsToday: json['reviewsToday'] ?? 0,
    );
  }

  int get level {
    int l = 1;
    while (totalXp >= totalXpRequiredForLevel(l + 1)) {
      l++;
    }
    return l;
  }

  int get currentLevelXp => totalXp - totalXpRequiredForLevel(level);

  int get xpForNextLevel {
    return xpRequiredForLevel(level) - currentLevelXp;
  }

  double get levelProgress => currentLevelXp / xpRequiredForLevel(level);

  // Helper methods for XP curve
  static int xpRequiredForLevel(int level) => 100 + ((level - 1) * 50);

  static int totalXpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    // Sum of arithmetic progression: (n/2)(2a + (n-1)d)
    // where n = level - 1, a = 100, d = 50
    // total = ((level-1)/2) * (200 + (level-2)*50)
    // total = (level-1) * (100 + (level-2)*25)
    // Example Level 3: (2) * (100 + (1)*25) = 2 * 125 = 250. Correct.
    return (level - 1) * (100 + (level - 2) * 25);
  }

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
    int? combo,
    int? bestStreak,
    int? totalStudyDays,
    List<DateTime>? studyDays,
    int? reviewsToday,
  }) {
    return UserProgress(
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      combo: combo ?? this.combo,
      bestStreak: bestStreak ?? this.bestStreak,
      totalStudyDays: totalStudyDays ?? this.totalStudyDays,
      studyDays: studyDays ?? this.studyDays,
      reviewsToday: reviewsToday ?? this.reviewsToday,
    );
  }
}
