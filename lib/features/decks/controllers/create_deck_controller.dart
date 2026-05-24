import '../services/deck_service.dart';

class CreateDeckController {
  final DeckService _deckService;

  CreateDeckController({required DeckService deckService})
    : _deckService = deckService;

  String? validateTitle(String title) {
    final trimmedTitle = title.trim();

    if (trimmedTitle.isEmpty) {
      return 'Title is required';
    }

    if (trimmedTitle.length > 100) {
      return 'Title must be 100 characters or less';
    }

    return null;
  }

  String? validateDescription(String description) {
    if (description.trim().length > 300) {
      return 'Description must be 300 characters or less';
    }

    return null;
  }

  Future<bool> createDeck({
    required String title,
    required String description,
  }) async {
    final titleError = validateTitle(title);
    final descriptionError = validateDescription(description);

    if (titleError != null || descriptionError != null) {
      return false;
    }

    await _deckService.createDeck(title: title, description: description);
    return true;
  }
}
