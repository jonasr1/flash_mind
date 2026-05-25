import '../models/deck.dart';
import '../services/deck_service.dart';

class CreateDeckController {
  final DeckService _deckService;

  CreateDeckController({required DeckService deckService})
    : _deckService = deckService;

  String? validateTitle(String title) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      return 'Título é obrigatório';
    }

    if (trimmedTitle.length > 100) {
      return 'O título deve ter 100 caracteres ou menos';
    }

    return null;
  }

  Future<String?> validateTitleUnique(String title) async {
    if (await _deckService.existsWithTitle(title)) {
      return 'Já existe um baralho com este título';
    }
    return null;
  }

  String? validateDescription(String description) {
    if (description.trim().length > 300) {
      return 'Description must be 300 characters or less';
    }

    return null;
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
