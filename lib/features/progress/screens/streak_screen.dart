import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import '../controllers/streak_controller.dart';
import '../widgets/streak_calendar.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth.year == now.year && _selectedMonth.month == now.month;
  }

  Widget buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Card(
        child: SizedBox(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressController = AppScope.of(context).userProgressController;
    progressController.refreshFor(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Ofensiva')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: progressController,
          builder: (context, _) {
            final controller = StreakController(
              progress: progressController.progress,
            );
            final monthTitle =
                '${StreakController.monthNames[_selectedMonth.month - 1]} ${_selectedMonth.year}';
            final studyDaysInMonth =
                controller.studyDaysCountInMonth(_selectedMonth);

            return Scrollbar(
              thumbVisibility: true,
              thickness: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.workspace_premium_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Nível atual: ${controller.level}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.currentStreak.toString(),
                              style: theme.textTheme.displayLarge,
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.fireplace_outlined, size: 60),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'dias seguidos estudando',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        buildStatCard(
                          context,
                          title: 'Total de dias estudados',
                          value: controller.totalStudyDays.toString(),
                        ),
                        const SizedBox(width: 12),
                        buildStatCard(
                          context,
                          title: 'Melhor sequência de dias',
                          value: controller.bestStreak.toString(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          monthTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _previousMonth,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            IconButton(
                              onPressed: _isCurrentMonth ? null : _nextMonth,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dias estudados: $studyDaysInMonth',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    StreakCalendar(
                      month: _selectedMonth,
                      days: controller.monthDays(_selectedMonth),
                      studyDays: controller.studyDays,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
