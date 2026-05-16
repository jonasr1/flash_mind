import 'package:flash_mind/features/flashcards/models/flashcard.dart';

class Deck {
  final String title;
  final int reviewedCards;
  final List<Flashcard> flashcards;

  const Deck({
    required this.title,
    required this.reviewedCards,
    required this.flashcards,
  });

  int get totalCards => flashcards.length;

  double get progress {
    if (totalCards == 0) return 0;
    return reviewedCards / totalCards;
  }
}
