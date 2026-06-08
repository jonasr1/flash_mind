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

  int get level => (totalXp ~/ 100) + 1;

  int get currentLevelXp => totalXp % 100;

  int get xpForNextLevel {
    final requiredXp = 100 + ((level - 1) * 50);
    return requiredXp - currentLevelXp;
  }

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
