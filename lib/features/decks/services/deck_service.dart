import 'package:flutter/foundation.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';
import '../repositories/deck_repository.dart';

class DeckService extends ChangeNotifier {
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
    notifyListeners();
    return deck;
  }

  Future<bool> existsWithTitle(String title) async {
    final decks = await getDecks();
    final trimmedTitle = title.trim().toLowerCase();
    return decks.any(
      (deck) => deck.title.trim().toLowerCase() == trimmedTitle,
    );
  }

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

  Future<String?> validateTitleUnique(String title, {String? excludeDeckId}) async {
    final decks = await getDecks();
    final trimmedTitle = title.trim().toLowerCase();
    final exists = decks.any(
      (deck) =>
          deck.id != excludeDeckId &&
          deck.title.trim().toLowerCase() == trimmedTitle,
    );
    if (exists) {
      return 'Já existe um baralho com este título';
    }
    return null;
  }

  String? validateDescription(String description) {
    if (description.trim().length > 300) {
      return 'A descrição deve ter 300 caracteres ou menos';
    }

    return null;
  }

  String? validateFlashcardUnique({
    required Deck deck,
    required String question,
    required String answer,
    String? excludeId,
  }) {
    final trimmedQuestion = question.trim().toLowerCase();
    final trimmedAnswer = answer.trim().toLowerCase();

    final exists = deck.flashcards.any((f) {
      if (excludeId != null && f.id == excludeId) return false;

      return f.question.trim().toLowerCase() == trimmedQuestion &&
          f.answer.trim().toLowerCase() == trimmedAnswer;
    });

    if (exists) {
      return 'Este flashcard já existe neste baralho.';
    }

    return null;
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
    notifyListeners();
  }

  Future<void> updateFlashcard({
    required Deck deck,
    required Flashcard flashcard,
    required String question,
    required String answer,
  }) async {
    flashcard.question = question.trim();
    flashcard.answer = answer.trim();

    await _repository.updateDeck(deck);
    notifyListeners();
  }

  Future<void> updateDeck(Deck deck) async {
    await _repository.updateDeck(deck);
    notifyListeners();
  }

  Future<void> deleteFlashcard({
    required Deck deck,
    required Flashcard flashcard,
  }) async {
    await _repository.deleteFlashcard(deck, flashcard);
    deck.flashcards.remove(flashcard);
    notifyListeners();
  }

  Future<void> deleteDeck(Deck deck) async {
    await _repository.deleteDeck(deck);
    notifyListeners();
  }
}
