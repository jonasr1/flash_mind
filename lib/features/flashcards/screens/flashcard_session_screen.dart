import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/widgets/answer_buttons.dart';
import 'package:flash_mind/features/flashcards/widgets/empty_review_state.dart';
import 'package:flash_mind/features/flashcards/widgets/session_header.dart';
import 'package:flash_mind/features/flashcards/widgets/session_progress.dart';
import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
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

  List<Flashcard> _getDueFlashcards(DateTime now) {
    return widget.deck.flashcards
        .where((card) => card.nextReviewAt.isBefore(now))
        .toList();
  }

  int _normalizeIndex(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return length - 1;
    return index;
  }

  Future<void> reviewCurrentFlashcard(ReviewRating rating) async {
    final currentDueFlashcards = _getDueFlashcards(DateTime.now());
    if (currentDueFlashcards.isEmpty) return;

    final safeCurrentIndex =
        _normalizeIndex(currentIndex, currentDueFlashcards.length);
    final currentCard = currentDueFlashcards[safeCurrentIndex];
    var shouldShowSessionCompletedDialog = false;

    await AppScope.of(context).reviewService.reviewFlashcard(widget.deck, currentCard, rating);

    if (!mounted) return;

    setState(() {
      isAnswerVisible = false;

      final updatedDueFlashcards = _getDueFlashcards(DateTime.now());
      shouldShowSessionCompletedDialog = updatedDueFlashcards.isEmpty;

      currentIndex =
          _normalizeIndex(safeCurrentIndex, updatedDueFlashcards.length);
    });

    if (shouldShowSessionCompletedDialog) {
      showSessionCompletedDialog();
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
    final dueFlashcards = _getDueFlashcards(DateTime.now());
    final safeCurrentIndex =
        _normalizeIndex(currentIndex, dueFlashcards.length);
    final currentFlashcard =
        dueFlashcards.isEmpty ? null : dueFlashcards[safeCurrentIndex];
    final progressController = AppScope.of(context).userProgressController;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SessionHeader(deckTitle: widget.deck.title),
              const SizedBox(height: 12),
              if (dueFlashcards.isNotEmpty) ...[
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: progressController,
                  builder: (context, _) {
                    return SessionProgress(
                      currentIndex: safeCurrentIndex,
                      totalCards: dueFlashcards.length,
                      combo: progressController.progress.combo,
                    );
                  },
                ),
              ],
              const SizedBox(height: 12),
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const SizedBox(height: 24),
              Expanded(
                child: dueFlashcards.isEmpty
                    ? const EmptyReviewState()
                    : FlashcardView(
                        question: currentFlashcard!.question,
                        answer: currentFlashcard.answer,
                        isAnswerVisible: isAnswerVisible,
                        onTap: showAnswer,
                      ),
              ),
              if (isAnswerVisible && dueFlashcards.isNotEmpty)
                AnswerButtons(onSelected: reviewCurrentFlashcard),
            ],
          ),
        ),
      ),
    );
  }
}
