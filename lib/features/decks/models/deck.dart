import 'package:flash_mind/features/flashcards/models/flashcard.dart';

class Deck {
  final String title;
  final List<Flashcard> flashcards;

  const Deck({required this.title, required this.flashcards});

  int get totalCards => flashcards.length;

  int get reviewedCards {
    return flashcards.where((card) => card.timesReviewed > 0).length;
  }

  double get progress {
    if (totalCards == 0) return 0;
    return reviewedCards / totalCards;
  }
}
