import '../models/user_progress.dart';
import 'package:flutter/material.dart';

class LevelCard extends StatelessWidget {
  final UserProgress progress;

  const LevelCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nível ${progress.level} - ${progress.title}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.progress,
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${progress.currentLevelXP} / 100 XP',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
