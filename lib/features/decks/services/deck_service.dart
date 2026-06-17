import 'package:flutter/foundation.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';
import '../repositories/deck_repository.dart';

class DeckService extends ChangeNotifier {
  final DeckRepository _repository;
  List<Deck> _decks = [];
  bool _isInitialized = false;

  DeckService({required DeckRepository repository}) : _repository = repository;

  Future<void> init() async {
    _decks = await _repository.getDecks();
    _isInitialized = true;
    notifyListeners();
  }

  List<Deck> get decks {
    return List.unmodifiable(_decks);
  }

  Future<List<Deck>> getDecks() async {
    if (!_isInitialized) {
      await init();
    }
    return _decks;
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
    if (!_isInitialized) {
      await init();
    } else {
      _decks.add(deck);
    }
    notifyListeners();
    return deck;
  }

  Future<bool> existsWithTitle(String title) async {
    final currentDecks = await getDecks();
    final trimmedTitle = title.trim().toLowerCase();
    return currentDecks.any(
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
    final currentDecks = await getDecks();
    final trimmedTitle = title.trim().toLowerCase();
    final exists = currentDecks.any(
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
    if (!_isInitialized) {
      await init();
    } else {
      final index = _decks.indexWhere((d) => d.id == deck.id);
      if (index != -1) {
        _decks[index].flashcards.add(flashcard);
      }
    }
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
    if (!_isInitialized) {
      await init();
    } else {
      final deckIndex = _decks.indexWhere((d) => d.id == deck.id);
      if (deckIndex != -1) {
        final cardIndex =
            _decks[deckIndex].flashcards.indexWhere((f) => f.id == flashcard.id);
        if (cardIndex != -1) {
          _decks[deckIndex].flashcards[cardIndex] = flashcard;
        }
      }
    }
    notifyListeners();
  }

  Future<void> updateDeck(Deck deck) async {
    await _repository.updateDeck(deck);
    if (!_isInitialized) {
      await init();
    } else {
      final index = _decks.indexWhere((d) => d.id == deck.id);
      if (index != -1) {
        _decks[index] = deck;
      }
    }
    notifyListeners();
  }

  Future<void> deleteFlashcard({
    required Deck deck,
    required Flashcard flashcard,
  }) async {
    await _repository.deleteFlashcard(deck, flashcard);
    if (!_isInitialized) {
      await init();
    } else {
      final deckIndex = _decks.indexWhere((d) => d.id == deck.id);
      if (deckIndex != -1) {
        _decks[deckIndex].flashcards.removeWhere((f) => f.id == flashcard.id);
      }
    }
    notifyListeners();
  }

  Future<void> deleteDeck(Deck deck) async {
    await _repository.deleteDeck(deck);
    if (!_isInitialized) {
      await init();
    } else {
      _decks.removeWhere((d) => d.id == deck.id);
    }
    notifyListeners();
  }
}
