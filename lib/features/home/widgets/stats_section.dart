import 'package:flutter/material.dart';

import '../models/stats_data.dart';

class StatsSection extends StatelessWidget {
  final StatsData stats;

  const StatsSection({super.key, required this.stats});

  Widget buildCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildCard(
          icon: Icons.local_fire_department,
          title: 'Sequência',
          value: '${stats.streakDays} dias',
        ),
        const SizedBox(width: 16),
        buildCard(
          icon: Icons.style,
          title: 'Revisados Hoje',
          value: '${stats.reviewedToday}',
        ),
      ],
    );
  }
}
