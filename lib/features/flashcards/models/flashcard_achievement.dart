enum AchievementType {
  rank(1),
  level(2),
  bestStreak(3),
  streak(4),
  combo(5);

  final int priority;
  const AchievementType(this.priority);
}

class FlashcardAchievement {
  final AchievementType type;
  final String message;

  const FlashcardAchievement({required this.type, required this.message});
}
