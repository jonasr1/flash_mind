import 'package:flash_mind/features/home/models/quote.dart';
import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote_rounded,
              size: 24,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              quote.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  quote.author,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
