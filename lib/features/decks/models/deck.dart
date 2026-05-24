import 'package:flash_mind/features/flashcards/models/flashcard.dart';

class Deck {
  final String id;
  final String title;
  final String description;
  final List<Flashcard> flashcards;
  final DateTime createdAt;
  final DateTime updatedAt;

  Deck({
    String? id,
    required this.title,
    this.description = '',
    required this.flashcards,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  int get totalCards => flashcards.length;

  int get reviewedCards {
    return flashcards.where((card) => card.timesReviewed > 0).length;
  }

  double get progress {
    if (totalCards == 0) return 0;
    return reviewedCards / totalCards;
  }
}
