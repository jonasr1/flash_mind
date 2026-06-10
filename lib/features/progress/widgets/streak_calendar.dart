import 'package:flutter/material.dart';

class StreakCalendar extends StatelessWidget {
  final DateTime month;
  final List<DateTime?> days;
  final Set<DateTime> studyDays;

  const StreakCalendar({
    super.key,
    required this.month,
    required this.days,
    required this.studyDays,
  });

  static const _weekdays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  bool isStudyDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return studyDays.contains(normalizedDay);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    _weekdays[index],
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              },
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                if (day == null) {
                  return const SizedBox.shrink();
                }

                final studied = isStudyDay(day);

                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: studied
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      day.day.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: studied
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
