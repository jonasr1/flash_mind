import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/features/progress/controllers/streak_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreakController', () {
    test('returns correct streak level title', () {
      final p1 = const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);
      expect(StreakController(progress: p1).level, 'Iniciante');

      final p2 = const UserProgress(totalXp: 0, streakDays: 7, lastStudyDate: null);
      expect(StreakController(progress: p2).level, 'Consistente');

      final p3 = const UserProgress(totalXp: 0, streakDays: 30, lastStudyDate: null);
      expect(StreakController(progress: p3).level, 'Dedicado');

      final p4 = const UserProgress(totalXp: 0, streakDays: 90, lastStudyDate: null);
      expect(StreakController(progress: p4).level, 'Mestre');

      final p5 = const UserProgress(totalXp: 0, streakDays: 365, lastStudyDate: null);
      expect(StreakController(progress: p5).level, 'Lendário');
    });

    test('monthDays generates correct number of days', () {
      final controller = const StreakController(
        progress: UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null),
      );
      
      // June 2026: 30 days. Starts on Monday (1).
      // weekday % 7: 1 % 7 = 1 leading empty day (Sunday is 0, Monday is 1... wait)
      // DateTime.weekday: Monday is 1, Sunday is 7.
      // firstDay.weekday % 7: 1 % 7 = 1 leading empty day if Monday.
      // If Monday is 1, and leadingEmptyDays is 1, then Sunday is null. Correct.
      
      final june2026 = DateTime(2026, 6, 1);
      final days = controller.monthDays(june2026);
      
      expect(days.length % 7, 0);
      expect(days.where((d) => d != null).length, 30);
    });

    test('studyDays returns unique dates without time', () {
      final now = DateTime(2026, 6, 3, 10, 30);
      final later = DateTime(2026, 6, 3, 15, 45);
      final progress = UserProgress(
        totalXp: 0, 
        streakDays: 1, 
        lastStudyDate: later,
        studyDays: [now, later],
      );
      
      final controller = StreakController(progress: progress);
      
      expect(controller.studyDays.length, 1);
      expect(controller.studyDays.first, DateTime(2026, 6, 3));
    });
  });
}
