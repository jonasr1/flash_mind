import 'package:flutter/material.dart';

import '../models/stats_data.dart';

class StatsSection extends StatelessWidget {
  final StatsData stats;

  const StatsSection({super.key, required this.stats});

  Widget buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCard(
          context,
          icon: Icons.local_fire_department_rounded,
          title: 'Sequência',
          value:
              '${stats.streakDays} ${stats.streakDays == 1 ? 'dia' : 'dias'}',
        ),
        const SizedBox(width: 12),
        buildCard(
          context,
          icon: Icons.style,
          title: 'Revisados Hoje',
          value: '${stats.reviewedToday}',
        ),
      ],
    );
  }
}
