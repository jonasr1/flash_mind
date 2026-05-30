import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';
import 'user_progress_repository.dart';

class LocalUserProgressRepository implements UserProgressRepository {
  static const String _key = 'flash_mind_user_progress';
  final SharedPreferences _prefs;

  LocalUserProgressRepository(this._prefs);

  @override
  Future<UserProgress> load() async {
    final String? progressJson = _prefs.getString(_key);
    if (progressJson == null) {
      return const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);
    }

    final Map<String, dynamic> decoded = jsonDecode(progressJson);
    return UserProgress.fromJson(decoded);
  }

  @override
  Future<void> save(UserProgress progress) async {
    final String encoded = jsonEncode(progress.toJson());
    await _prefs.setString(_key, encoded);
  }
}
