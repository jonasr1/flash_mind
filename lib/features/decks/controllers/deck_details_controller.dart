import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';
import '../services/deck_service.dart';

class DeckDetailsController {
  final DeckService _deckService;

  DeckDetailsController({required DeckService deckService})
    : _deckService = deckService;

  Future<void> deleteFlashcard({
    required Deck deck,
    required Flashcard flashcard,
  }) {
    return _deckService.deleteFlashcard(deck: deck, flashcard: flashcard);
  }
}
