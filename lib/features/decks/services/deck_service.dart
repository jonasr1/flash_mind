import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';
import '../repositories/deck_repository.dart';

class DeckService {
  final DeckRepository _repository;

  DeckService({required DeckRepository repository}) : _repository = repository;

  Future<List<Deck>> getDecks() {
    return _repository.getDecks();
  }

  Future<void> createDeck({required String title, String description = ''}) {
    final now = DateTime.now();
    final deck = Deck(
      id: now.microsecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      flashcards: <Flashcard>[],
      createdAt: now,
      updatedAt: now,
    );

    return _repository.createDeck(deck);
  }
}
