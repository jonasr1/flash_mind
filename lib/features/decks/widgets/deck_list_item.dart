import 'package:flutter/material.dart';

import '../models/deck.dart';

class DeckListItem extends StatelessWidget {
  final Deck deck;

  const DeckListItem({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// linha superior: título + menu
            Row(
              children: [
                Expanded(
                  child: Text(deck.title, style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// progresso textual
            Text(
              '${deck.reviewedCards}/${deck.totalCards} revisados',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 12),

            /// barra de progresso
            LinearProgressIndicator(
              value: deck.progress,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
