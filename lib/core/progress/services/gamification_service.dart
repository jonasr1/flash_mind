import 'package:flash_mind/features/flashcards/models/review_rating.dart';

import '../models/user_progress.dart';

class GamificationService {
  const GamificationService();

  int xpForRating(ReviewRating rating) {
    switch (rating) {
      case ReviewRating.forgot:
        return 5;
      case ReviewRating.difficult:
        return 10;
      case ReviewRating.easy:
        return 15;
    }
  }

  UserProgress applyReview(
    UserProgress progress,
    ReviewRating rating, {
    required DateTime now,
  }) {
    final earnedXp = xpForRating(rating);

    final today = DateTime(now.year, now.month, now.day);
    final last = progress.lastStudyDate;

    int streakDays = progress.streakDays;
    DateTime? lastStudyDate = last;
    int combo = progress.combo;

    if (last != null) {
      final lastDay = DateTime(last.year, last.month, last.day);

      if (lastDay != today) {
        final isConsecutive = lastDay.add(const Duration(days: 1)) == today;
        streakDays = isConsecutive ? streakDays + 1 : 1;
        lastStudyDate = today;
        combo = 0;
      }
    } else {
      streakDays = 1;
      lastStudyDate = today;
      combo = 0;
    }

    switch (rating) {
      case ReviewRating.forgot:
        combo = 0;
        break;
      case ReviewRating.difficult:
      case ReviewRating.easy:
        combo += 1;
        break;
    }

    return progress.copyWith(
      totalXp: progress.totalXp + earnedXp,
      streakDays: streakDays,
      lastStudyDate: lastStudyDate,
      combo: combo,
    );
  }
}
