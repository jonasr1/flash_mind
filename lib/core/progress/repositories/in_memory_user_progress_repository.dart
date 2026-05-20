import '../models/user_progress.dart';
import 'user_progress_repository.dart';

class InMemoryUserProgressRepository implements UserProgressRepository {
  UserProgress _progress =
      const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);

  @override
  Future<UserProgress> load() async {
    return _progress;
  }

  @override
  Future<void> save(UserProgress progress) async {
    _progress = progress;
  }
}
