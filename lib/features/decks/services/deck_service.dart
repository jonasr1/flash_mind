import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';
import '../repositories/deck_repository.dart';

class DeckService {
  final DeckRepository _repository;

  DeckService({required DeckRepository repository}) : _repository = repository;

  Future<List<Deck>> getDecks() {
    return _repository.getDecks();
  }

  Future<Deck> createDeck({
    required String title,
    String description = '',
  }) async {
    final now = DateTime.now();
    final deck = Deck(
      id: now.microsecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      flashcards: <Flashcard>[],
      createdAt: now,
      updatedAt: now,
    );

    await _repository.createDeck(deck);
    return deck;
  }

  Future<bool> existsWithTitle(String title) async {
    final decks = await getDecks();
    final trimmedTitle = title.trim().toLowerCase();
    return decks.any(
      (deck) => deck.title.trim().toLowerCase() == trimmedTitle,
    );
  }

  Future<void> addFlashcard({
    required Deck deck,
    required String question,
    required String answer,
  }) async {
    final flashcard = Flashcard(
      question: question.trim(),
      answer: answer.trim(),
    );

    await _repository.addFlashcard(deck, flashcard);
    deck.flashcards.add(flashcard);
  }

  Future<void> updateFlashcard({
    required Deck deck,
    required Flashcard flashcard,
    required String question,
    required String answer,
  }) async {
    flashcard.question = question.trim();
    flashcard.answer = answer.trim();

    await _repository.updateFlashcard(deck, flashcard);
  }

  Future<void> deleteFlashcard({
    required Deck deck,
    required Flashcard flashcard,
  }) async {
    await _repository.deleteFlashcard(deck, flashcard);
    deck.flashcards.remove(flashcard);
  }

  Future<void> deleteDeck(Deck deck) {
    return _repository.deleteDeck(deck);
  }
}
