import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/decks/screens/deck_details_screen.dart';
import 'package:flash_mind/features/flashcards/screens/flashcard_session_screen.dart';
import 'package:flash_mind/features/home/widgets/onboarding_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../models/deck.dart';

class DeckListItem extends StatelessWidget {
  final Deck deck;
  final VoidCallback? onDeckUpdated;
  final GlobalKey? showcaseKey;

  const DeckListItem({
    super.key,
    required this.deck,
    this.onDeckUpdated,
    this.showcaseKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final card = Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FlashcardSessionScreen(deck: deck),
            ),
          );
          if (!context.mounted) return;
          onDeckUpdated?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(deck.title, style: theme.textTheme.titleMedium),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'details') {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DeckDetailsScreen(deck: deck),
                          ),
                        );

                        if (!context.mounted) return;
                        onDeckUpdated?.call();
                      }

                      if (value == 'delete') {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Apagar baralho'),
                            content: Text('Deseja apagar "${deck.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Apagar'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          if (!context.mounted) return;
                          await AppScope.of(
                            context,
                          ).deckService.deleteDeck(deck);
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Baralho apagado com sucesso'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          onDeckUpdated?.call();
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'details',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Editar baralho'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline_rounded),
                          title: Text('Apagar baralho'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${deck.reviewedCards}/${deck.totalCards} revisados',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: deck.progress,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ),
      ),
    );

    if (showcaseKey != null) {
      return Showcase.withWidget(
        scope: 'decks',
        key: showcaseKey!,
        targetBorderRadius: BorderRadius.circular(16),
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        container: OnboardingTooltip(
          title: 'Iniciar Estudos',
          description: 'Toque em qualquer baralho para iniciar uma sessão de estudos.',
          currentStep: 2,
          totalSteps: 2,
          onNext: () => ShowcaseView.getNamed('decks').dismiss(),
          onSkip: () => ShowcaseView.getNamed('decks').dismiss(),
        ),
        child: card,
      );
    }

    return card;
  }
}
