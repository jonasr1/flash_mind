import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProgress', () {
    test('calculates level correctly based on XP', () {
      expect(const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null).level, 1);
      expect(const UserProgress(totalXp: 99, streakDays: 0, lastStudyDate: null).level, 1);
      expect(const UserProgress(totalXp: 100, streakDays: 0, lastStudyDate: null).level, 2);
      expect(const UserProgress(totalXp: 249, streakDays: 0, lastStudyDate: null).level, 2);
      expect(const UserProgress(totalXp: 250, streakDays: 0, lastStudyDate: null).level, 3);
      expect(const UserProgress(totalXp: 449, streakDays: 0, lastStudyDate: null).level, 3);
      expect(const UserProgress(totalXp: 450, streakDays: 0, lastStudyDate: null).level, 4);
      expect(const UserProgress(totalXp: 699, streakDays: 0, lastStudyDate: null).level, 4);
      expect(const UserProgress(totalXp: 700, streakDays: 0, lastStudyDate: null).level, 5);
    });

    test('calculates level progress and XP for next level', () {
      // Example: totalXp = 320
      // level = 3 (Start at 250)
      // currentLevelXp = 320 - 250 = 70
      // xpRequiredForLevel(3) = 100 + (3-1)*50 = 200
      // xpForNextLevel = 200 - 70 = 130
      // levelProgress = 70 / 200 = 0.35
      const progress = UserProgress(totalXp: 320, streakDays: 0, lastStudyDate: null);
      
      expect(progress.level, 3);
      expect(progress.currentLevelXp, 70);
      expect(progress.xpForNextLevel, 130);
      expect(progress.levelProgress, 0.35);
    });

    test('returns correct title based on level', () {
      expect(const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null).title, 'Iniciante'); // Level 1
      expect(const UserProgress(totalXp: 100, streakDays: 0, lastStudyDate: null).title, 'Aprendiz'); // Level 2
      expect(const UserProgress(totalXp: 700, streakDays: 0, lastStudyDate: null).title, 'Desbravador'); // Level 5
      expect(const UserProgress(totalXp: 2700, streakDays: 0, lastStudyDate: null).title, 'Mestre'); // Level 10
    });

    test('toJson and fromJson work correctly', () {
      final now = DateTime(2026, 6, 3);
      final progress = UserProgress(
        totalXp: 100,
        streakDays: 5,
        lastStudyDate: now,
        bestStreak: 10,
        totalStudyDays: 15,
        studyDays: [now],
      );

      final json = progress.toJson();
      final fromJson = UserProgress.fromJson(json);

      expect(fromJson.totalXp, progress.totalXp);
      expect(fromJson.streakDays, progress.streakDays);
      expect(fromJson.lastStudyDate, progress.lastStudyDate);
      expect(fromJson.bestStreak, progress.bestStreak);
      expect(fromJson.totalStudyDays, progress.totalStudyDays);
      expect(fromJson.studyDays.length, progress.studyDays.length);
      expect(fromJson.studyDays.first, progress.studyDays.first);
    });
  });
}
