import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flutter/material.dart';
import 'package:flash_mind/features/flashcards/data/flashcards_data.dart';

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

  void goToNextFlashcard() {
    if (currentIndex >= flashcards.length - 1) {
      return;
    }

    setState(() {
      currentIndex++;
      isAnswerVisible = false;
    });
  }

  void showAnswer() {
    setState(() {
      isAnswerVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFlashcard = flashcards[currentIndex];
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
                    '${currentIndex + 1}/${flashcards.length}',
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
                        onPressed: goToNextFlashcard,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _ActionButton(
                        label: 'Difícil',
                        color: Colors.orange,
                        onPressed: goToNextFlashcard,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: _ActionButton(
                        label: 'Fácil',
                        color: Colors.green,
                        onPressed: goToNextFlashcard,
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
