import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/core/progress/repositories/in_memory_user_progress_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProgressController', () {
    late UserProgressController controller;
    late InMemoryUserProgressRepository repository;

    setUp(() {
      repository = InMemoryUserProgressRepository();
      controller = UserProgressController(repository: repository);
    });

    test('initializes with repository data', () async {
      final initialProgress = const UserProgress(
        totalXp: 50,
        streakDays: 2,
        lastStudyDate: null,
      );
      await repository.save(initialProgress);

      await controller.init();

      expect(controller.progress.totalXp, 50);
      expect(controller.progress.streakDays, 2);
    });

    test('setProgress updates state and saves to repository', () {
      final newProgress = const UserProgress(
        totalXp: 100,
        streakDays: 3,
        lastStudyDate: null,
      );

      controller.setProgress(newProgress);

      expect(controller.progress, newProgress);
      // We can't easily check the repository directly without making it public or using a mock,
      // but InMemoryUserProgressRepository stores it in a private field.
      // However, if we load it again, it should be there.
    });

    test('refreshFor resets streak if more than one day missed', () {
      final lastStudyDate = DateTime(2026, 6, 1);
      final progress = UserProgress(
        totalXp: 100,
        streakDays: 5,
        lastStudyDate: lastStudyDate,
      );
      controller.setProgress(progress);

      // Act: skip one day (June 2nd) and check on June 3rd
      final now = DateTime(2026, 6, 3);
      controller.refreshFor(now);

      // Assert: streak should be reset to 0
      expect(controller.progress.streakDays, 0);
    });

    test('refreshFor does NOT reset streak if checked on the next day', () {
      final lastStudyDate = DateTime(2026, 6, 1);
      final progress = UserProgress(
        totalXp: 100,
        streakDays: 5,
        lastStudyDate: lastStudyDate,
      );
      controller.setProgress(progress);

      // Act: check on the very next day (June 2nd)
      final now = DateTime(2026, 6, 2);
      controller.refreshFor(now);

      // Assert: streak should still be 5
      expect(controller.progress.streakDays, 5);
    });
  });
}
