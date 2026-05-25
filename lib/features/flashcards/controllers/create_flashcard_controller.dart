import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';

class CreateFlashcardController {
  final DeckService _deckService;

  CreateFlashcardController({required DeckService deckService})
      : _deckService = deckService;

  String? validateQuestion(String question) {
    if (question.trim().isEmpty) {
      return 'A pergunta é obrigatória';
    }
    return null;
  }

  String? validateAnswer(String answer) {
    if (answer.trim().isEmpty) {
      return 'A resposta é obrigatória';
    }
    return null;
  }

  Future<void> createFlashcard({
    required Deck deck,
    required String question,
    required String answer,
  }) async {
    final questionError = validateQuestion(question);
    final answerError = validateAnswer(answer);

    if (questionError != null || answerError != null) {
      throw ArgumentError('Invalid flashcard data');
    }

    await _deckService.addFlashcard(
      deck: deck,
      question: question,
      answer: answer,
    );
  }
}
