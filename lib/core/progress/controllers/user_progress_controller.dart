import 'package:flutter/foundation.dart';

import '../models/user_progress.dart';
import '../repositories/user_progress_repository.dart';

class UserProgressController extends ChangeNotifier {
  final UserProgressRepository _repository;

  UserProgress _progress =
      const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);
  UserProgress get progress => _progress;

  UserProgressController({required UserProgressRepository repository})
      : _repository = repository;

  Future<void> init() async {
    _progress = await _repository.load();
    notifyListeners();
  }

  void setProgress(UserProgress progress) {
    _progress = progress;
    notifyListeners();
    _repository.save(_progress);
  }

  /// Call when entering Home (or app resume) to ensure streak resets if user
  /// skipped one or more days without studying.
  void refreshFor(DateTime now) {
    final last = _progress.lastStudyDate;
    if (last == null) return;

    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(last.year, last.month, last.day);

    bool changed = false;
    UserProgress newProgress = _progress;

    // If missed at least one day since last study, the streak is no longer active.
    if (lastDay.add(const Duration(days: 1)).isBefore(today) &&
        _progress.streakDays != 0) {
      newProgress = newProgress.copyWith(streakDays: 0);
      changed = true;
    }

    // Reset daily reviews if it's a new day
    if (lastDay != today && _progress.reviewsToday != 0) {
      newProgress = newProgress.copyWith(reviewsToday: 0);
      changed = true;
    }

    if (changed) {
      _progress = newProgress;
      notifyListeners();
      _repository.save(_progress);
    }
  }
}
