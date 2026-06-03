import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProgress', () {
    test('calculates level correctly based on XP', () {
      expect(const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null).level, 1);
      expect(const UserProgress(totalXp: 99, streakDays: 0, lastStudyDate: null).level, 1);
      expect(const UserProgress(totalXp: 100, streakDays: 0, lastStudyDate: null).level, 2);
      expect(const UserProgress(totalXp: 250, streakDays: 0, lastStudyDate: null).level, 3);
    });

    test('calculates level progress and XP for next level', () {
      const progress = UserProgress(totalXp: 150, streakDays: 0, lastStudyDate: null);
      
      expect(progress.currentLevelXp, 50);
      expect(progress.xpForNextLevel, 50);
      expect(progress.levelProgress, 0.5);
    });

    test('returns correct title based on level', () {
      expect(const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null).title, 'Iniciante'); // Level 1
      expect(const UserProgress(totalXp: 100, streakDays: 0, lastStudyDate: null).title, 'Aprendiz'); // Level 2
      expect(const UserProgress(totalXp: 400, streakDays: 0, lastStudyDate: null).title, 'Desbravador'); // Level 5
      expect(const UserProgress(totalXp: 900, streakDays: 0, lastStudyDate: null).title, 'Mestre'); // Level 10
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
