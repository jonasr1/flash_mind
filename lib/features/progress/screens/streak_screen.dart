import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import '../controllers/streak_controller.dart';
import '../widgets/streak_calendar.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

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
            final currentMonth = DateTime.now();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Nível atual: Iniciante',
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
                            controller.totalStudyDays.toString(),
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
                  const SizedBox(height: 16),
                  StreakCalendar(
                    month: currentMonth,
                    days: controller.monthDays(currentMonth),
                    studyDays: controller.studyDays,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
