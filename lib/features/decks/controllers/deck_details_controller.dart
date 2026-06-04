import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';
import '../services/deck_service.dart';

class DeckDetailsController {
  final DeckService _deckService;

  DeckDetailsController({required DeckService deckService})
    : _deckService = deckService;

  String? validateTitle(String title) {
    return _deckService.validateTitle(title);
  }

  Future<String?> validateTitleUnique(String title, String excludeDeckId) async {
    return _deckService.validateTitleUnique(title, excludeDeckId: excludeDeckId);
  }

  String? validateDescription(String description) {
    return _deckService.validateDescription(description);
  }

  Future<void> updateDeck({
    required Deck deck,
    required String title,
    required String description,
  }) async {
    final titleError = validateTitle(title);
    final descriptionError = validateDescription(description);

    if (titleError != null || descriptionError != null) {
      throw ArgumentError('Invalid deck data');
    }

    final uniqueError = await validateTitleUnique(title, deck.id);
    if (uniqueError != null) {
      throw ArgumentError(uniqueError);
    }

    final updatedDeck = deck.copyWith(
      title: title.trim(),
      description: description.trim(),
      updatedAt: DateTime.now(),
    );

    await _deckService.updateDeck(updatedDeck);
  }

  Future<void> deleteFlashcard({
    required Deck deck,
    required Flashcard flashcard,
  }) {
    return _deckService.deleteFlashcard(deck: deck, flashcard: flashcard);
  }
}
