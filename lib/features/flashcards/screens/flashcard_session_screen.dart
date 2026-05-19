import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/services/spaced_repetition_service.dart';
import 'package:flutter/material.dart';

import '../widgets/flashcard_view.dart';

class FlashcardSessionScreen extends StatefulWidget {
  final Deck deck;

  const FlashcardSessionScreen({super.key, required this.deck});

  @override
  State<FlashcardSessionScreen> createState() => _FlashcardSessionScreenState();
}

class _FlashcardSessionScreenState extends State<FlashcardSessionScreen> {
  bool isAnswerVisible = false;
  int currentIndex = 0;
  final spacedRepetitionService = SpacedRepetitionService();
  List<Flashcard> get dueFlashcards {
    return widget.deck.flashcards
        .where((card) => card.nextReviewAt.isBefore(DateTime.now()))
        .toList();
  }

  void reviewCurrentFlashcard(ReviewRating rating) {
    final currentCard = dueFlashcards[currentIndex];

    setState(() {
      spacedRepetitionService.reviewCard(currentCard, rating);
      isAnswerVisible = false;
    });

    final hasMoreCards = currentIndex < dueFlashcards.length;

    if (!hasMoreCards) {
      showSessionCompletedDialog();
      return;
    }
  }

  void showSessionCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sessão concluída 🎉'),
          content: const Text(
            'Você revisou todos os flashcards deste baralho.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
          ],
        );
      },
    );
  }

  void showAnswer() {
    setState(() {
      isAnswerVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (dueFlashcards.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: Center(child: Text('Nenhum flashcard para revisar agora 🎉')),
        ),
      );
    }
    final currentFlashcard = dueFlashcards[currentIndex];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                  Text(
                    'Baralho: ${widget.deck.title}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '${currentIndex + 1}/${dueFlashcards.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 18,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Combo: 3',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: 24),
              Expanded(
                child: FlashcardView(
                  question: currentFlashcard.question,
                  answer: currentFlashcard.answer,
                  isAnswerVisible: isAnswerVisible,
                  onTap: showAnswer,
                ),
              ),
              if (isAnswerVisible) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _ActionButton(
                        label: 'Não sabia',
                        color: Colors.red,
                        onPressed: () =>
                            reviewCurrentFlashcard(ReviewRating.forgot),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _ActionButton(
                        label: 'Difícil',
                        color: Colors.orange,
                        onPressed: () =>
                            reviewCurrentFlashcard(ReviewRating.difficult),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _ActionButton(
                        label: 'Fácil',
                        color: Colors.green,
                        onPressed: () =>
                            reviewCurrentFlashcard(ReviewRating.easy),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 44),
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}
