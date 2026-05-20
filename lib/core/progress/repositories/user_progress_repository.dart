import '../models/user_progress.dart';

abstract interface class UserProgressRepository {
  Future<UserProgress> load();
  Future<void> save(UserProgress progress);
}

