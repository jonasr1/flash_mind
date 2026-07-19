import 'package:flutter/material.dart';

class DeckStatesHelpBottomSheet extends StatelessWidget {
  const DeckStatesHelpBottomSheet({super.key});

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
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
    final colorScheme = theme.colorScheme;

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
            'Estados dos Flashcards',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Entenda como funciona o ciclo de aprendizado com repetição espaçada.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _buildHelpItem(
            context,
            icon: Icons.alarm_rounded,
            iconColor: colorScheme.primary,
            title: 'Para estudar',
            description:
                'Cartões que ainda precisam iniciar ou continuar o processo de revisão periódica de acordo com o intervalo planejado.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.loop_rounded,
            iconColor: Colors.orange,
            title: 'Em progresso',
            description:
                'Cartões em fase de aprendizado, que estão sendo revisados periodicamente para consolidar o conhecimento na memória.',
          ),
          _buildHelpItem(
            context,
            icon: Icons.check_circle_outline_rounded,
            iconColor: Colors.green,
            title: 'Dominado',
            description:
                'Cartões que apresentaram bom desempenho de forma consistente em várias revisões. O aplicativo aumenta gradualmente o intervalo entre as próximas revisões, mas revisões futuras ainda podem ocorrer para evitar o esquecimento.',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

void showDeckStatesHelp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const DeckStatesHelpBottomSheet(),
  );
}
