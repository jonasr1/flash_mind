import 'package:flutter/material.dart';

class DecksSummary extends StatelessWidget {
  const DecksSummary({super.key});

  Widget buildItem(
    BuildContext context, {
    required String title,
    required String value,
    required Color valueColor,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: valueColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          children: [
            buildItem(
              context,
              title: 'Para estudar',
              value: '12',
              valueColor: colorScheme.primary,
            ),
            Container(height: 45, width: 2, color: colorScheme.outlineVariant),
            buildItem(
              context,
              title: 'Em progresso',
              value: '4',
              valueColor: Colors.orange,
            ),
            Container(height: 45, width: 2, color: colorScheme.outlineVariant),
            buildItem(
              context,
              title: 'Dominado',
              value: '8',
              valueColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
