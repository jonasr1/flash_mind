import 'package:flash_mind/core/progress/models/user_progress.dart';

class StreakController {
  final UserProgress progress;

  const StreakController({required this.progress});

  static const monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  int get currentStreak => progress.currentStreak;

  int get bestStreak => progress.bestStreak;

  int get totalStudyDays => progress.totalStudyDays;

  Set<DateTime> get studyDays {
    return progress.studyDays
        .map((day) => DateTime(day.year, day.month, day.day))
        .toSet();
  }

  int studyDaysCountInMonth(DateTime month) {
    return studyDays.where((d) {
      return d.year == month.year && d.month == month.month;
    }).length;
  }

  String get level {
    final streak = currentStreak;

    if (streak >= 365) return 'Lendário';
    if (streak >= 90) return 'Mestre';
    if (streak >= 30) return 'Dedicado';
    if (streak >= 7) return 'Consistente';
    return 'Iniciante';
  }

  List<DateTime?> monthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmptyDays = firstDay.weekday % 7;
    final days = <DateTime?>[];

    for (var index = 0; index < leadingEmptyDays; index++) {
      days.add(null);
    }

    for (var day = 1; day <= daysInMonth; day++) {
      days.add(DateTime(month.year, month.month, day));
    }

    while (days.length % 7 != 0) {
      days.add(null);
    }

    return days;
  }
}
