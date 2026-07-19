import 'package:flutter/material.dart';

import 'package:flash_mind/features/decks/models/deck.dart';
import 'deck_states_help_bottom_sheet.dart';

class DecksSummary extends StatelessWidget {
  final List<Deck> decks;

  const DecksSummary({super.key, required this.decks});

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

    var dueCount = 0;
    var inProgressCount = 0;
    var masteredCount = 0;

    for (final deck in decks) {
      for (final card in deck.flashcards) {
        if (card.isDue) dueCount++;
        if (card.isInProgress) inProgressCount++;
        if (card.isMastered) masteredCount++;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 24,
                width: 24,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => showDeckStatesHelp(context),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                buildItem(
                  context,
                  title: 'Para estudar',
                  value: dueCount.toString(),
                  valueColor: colorScheme.primary,
                ),
                Container(height: 45, width: 2, color: colorScheme.outlineVariant),
                buildItem(
                  context,
                  title: 'Em progresso',
                  value: inProgressCount.toString(),
                  valueColor: Colors.orange,
                ),
                Container(height: 45, width: 2, color: colorScheme.outlineVariant),
                buildItem(
                  context,
                  title: 'Dominado',
                  value: masteredCount.toString(),
                  valueColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
