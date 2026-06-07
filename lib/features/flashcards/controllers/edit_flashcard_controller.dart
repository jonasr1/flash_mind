import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

class EditFlashcardController {
  final DeckService _deckService;

  EditFlashcardController({required DeckService deckService})
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

  String? validateDuplicate({
    required Deck deck,
    required String question,
    required String answer,
    required String excludeId,
  }) {
    return _deckService.validateFlashcardUnique(
      deck: deck,
      question: question,
      answer: answer,
      excludeId: excludeId,
    );
  }

  Future<void> updateFlashcard({
    required Deck deck,
    required Flashcard flashcard,
    required String question,
    required String answer,
  }) async {
    final questionError = validateQuestion(question);
    final answerError = validateAnswer(answer);
    final duplicateError = validateDuplicate(
      deck: deck,
      question: question,
      answer: answer,
      excludeId: flashcard.id,
    );

    if (questionError != null || answerError != null || duplicateError != null) {
      throw ArgumentError('Invalid flashcard data');
    }

    await _deckService.updateFlashcard(
      deck: deck,
      flashcard: flashcard,
      question: question,
      answer: answer,
    );
  }
}
