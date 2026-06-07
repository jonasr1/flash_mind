import 'package:flutter/material.dart';

class StatsHelpBottomSheet extends StatelessWidget {
  const StatsHelpBottomSheet({super.key});

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Estatísticas',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Entenda o que cada estatística significa.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _buildHelpItem(
            context,
            icon: Icons.local_fire_department_rounded,
            title: 'Sequência',
            description: 'Quantidade de dias seguidos em que você estudou.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.style,
            title: 'Cards Estudados',
            description:
                'Quantidade de flashcards diferentes estudados hoje.\nSe você revisar o mesmo card várias vezes, ele será contado apenas uma vez.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.loop_rounded,
            title: 'Revisões Feitas',
            description:
                'Quantidade total de revisões realizadas hoje.\nO mesmo card pode ser revisado várias vezes e cada revisão é contabilizada.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.alarm_rounded,
            title: 'Cards Disponíveis',
            description:
                'Quantidade de flashcards que podem ser revisados neste momento.\nA disponibilidade é determinada pelo sistema de repetição espaçada.',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

void showStatsHelp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const StatsHelpBottomSheet(),
  );
}
