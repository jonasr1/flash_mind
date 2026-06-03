import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/core/progress/services/gamification_service.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GamificationService service;

  setUp(() {
    service = const GamificationService();
  });

  UserProgress newProgress() {
    return const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);
  }

  UserProgress registerStudyDay(UserProgress progress, DateTime day) {
    return service.applyReview(progress, ReviewRating.easy, now: day);
  }

  test('first study day starts streak and registers one study day', () {
    // Arrange
    var progress = newProgress();

    // Act
    progress = registerStudyDay(progress, DateTime(2026, 1, 1));

    // Assert
    expect(progress.currentStreak, 1);
    expect(progress.bestStreak, 1);
    expect(progress.totalStudyDays, 1);
  });

  test('consecutive study days increase current and best streak', () {
    // Arrange
    var progress = newProgress();

    // Act
    progress = registerStudyDay(progress, DateTime(2026, 1, 1));
    progress = registerStudyDay(progress, DateTime(2026, 1, 2));
    progress = registerStudyDay(progress, DateTime(2026, 1, 3));

    // Assert
    expect(progress.currentStreak, 3);
    expect(progress.bestStreak, 3);
    expect(progress.totalStudyDays, 3);
  });

  test('broken streak resets current streak and keeps best streak', () {
    // Arrange
    var progress = newProgress();
    progress = registerStudyDay(progress, DateTime(2026, 1, 1));
    progress = registerStudyDay(progress, DateTime(2026, 1, 2));
    progress = registerStudyDay(progress, DateTime(2026, 1, 3));

    // Act
    progress = registerStudyDay(progress, DateTime(2026, 1, 5));

    // Assert
    expect(progress.currentStreak, 1);
    expect(progress.bestStreak, 3);
    expect(progress.totalStudyDays, 4);
  });

  test('best streak updates when a later streak is longer', () {
    // Arrange
    var progress = newProgress();
    progress = registerStudyDay(progress, DateTime(2026, 1, 1));
    progress = registerStudyDay(progress, DateTime(2026, 1, 2));
    progress = registerStudyDay(progress, DateTime(2026, 1, 3));

    // Act
    progress = registerStudyDay(progress, DateTime(2026, 1, 5));
    progress = registerStudyDay(progress, DateTime(2026, 1, 6));
    progress = registerStudyDay(progress, DateTime(2026, 1, 7));
    progress = registerStudyDay(progress, DateTime(2026, 1, 8));
    progress = registerStudyDay(progress, DateTime(2026, 1, 9));

    // Assert
    expect(progress.currentStreak, 5);
    expect(progress.bestStreak, 5);
    expect(progress.totalStudyDays, 8);
  });

  test('same day does not count twice', () {
    // Arrange
    var progress = newProgress();

    // Act
    progress = registerStudyDay(progress, DateTime(2026, 1, 1, 8));
    progress = registerStudyDay(progress, DateTime(2026, 1, 1, 12));
    progress = registerStudyDay(progress, DateTime(2026, 1, 1, 20));

    // Assert
    expect(progress.currentStreak, 1);
    expect(progress.bestStreak, 1);
    expect(progress.totalStudyDays, 1);
  });
}
