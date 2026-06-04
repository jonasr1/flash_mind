import '../models/deck.dart';
import '../services/deck_service.dart';

class CreateDeckController {
  final DeckService _deckService;

  CreateDeckController({required DeckService deckService})
    : _deckService = deckService;

  String? validateTitle(String title) {
    return _deckService.validateTitle(title);
  }

  Future<String?> validateTitleUnique(String title) async {
    return _deckService.validateTitleUnique(title);
  }

  String? validateDescription(String description) {
    return _deckService.validateDescription(description);
  }

  Future<Deck> createDeck({
    required String title,
    required String description,
  }) async {
    final titleError = validateTitle(title);
    final descriptionError = validateDescription(description);

    if (titleError != null || descriptionError != null) {
      throw ArgumentError('Invalid deck data');
    }

    final uniqueError = await validateTitleUnique(title);
    if (uniqueError != null) {
      throw ArgumentError(uniqueError);
    }

    return _deckService.createDeck(title: title, description: description);
  }
}
