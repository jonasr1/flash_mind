import '../models/user_progress.dart';

@Deprecated('Use AppScope.of(context).userProgressController instead.')
UserProgress userProgress =
    const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);
