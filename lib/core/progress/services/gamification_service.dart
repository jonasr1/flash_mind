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
    final studyDays = progress.studyDays
        .map((day) => DateTime(day.year, day.month, day.day))
        .toList();

    int streakDays = progress.streakDays;
    DateTime? lastStudyDate = last;
    int combo = progress.combo;
    var bestStreak = progress.bestStreak;
    int reviewsToday = progress.reviewsToday;

    if (last != null) {
      final lastDay = DateTime(last.year, last.month, last.day);

      if (lastDay != today) {
        final isConsecutive = lastDay.add(const Duration(days: 1)) == today;
        streakDays = isConsecutive ? streakDays + 1 : 1;
        lastStudyDate = today;
        combo = 0;
        reviewsToday = 1;
      } else {
        reviewsToday++;
      }
    } else {
      streakDays = 1;
      lastStudyDate = today;
      combo = 0;
      reviewsToday = 1;
    }

    final hasStudiedToday = studyDays.any((day) => day == today);
    if (!hasStudiedToday) {
      studyDays.add(today);
    }

    if (streakDays > bestStreak) {
      bestStreak = streakDays;
    }

    switch (rating) {
      case ReviewRating.forgot:
        combo = 0;
        break;
      case ReviewRating.difficult:
        // combo unchanged
        break;
      case ReviewRating.easy:
        combo += 1;
        break;
    }

    return progress.copyWith(
      totalXp: progress.totalXp + earnedXp,
      streakDays: streakDays,
      lastStudyDate: lastStudyDate,
      combo: combo,
      bestStreak: bestStreak,
      totalStudyDays: studyDays.length,
      studyDays: studyDays,
      reviewsToday: reviewsToday,
    );
  }
}
