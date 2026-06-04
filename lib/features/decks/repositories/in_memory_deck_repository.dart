import '../data/decks_data.dart';
import '../models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'deck_repository.dart';

class InMemoryDeckRepository implements DeckRepository {
  @override
  Future<List<Deck>> getDecks() async {
    return decks;
  }

  @override
  Future<void> createDeck(Deck deck) async {
    decks.add(deck);
  }

  @override
  Future<void> addFlashcard(Deck deck, Flashcard flashcard) async {
    deck.flashcards.add(flashcard);
  }

  @override
  Future<void> deleteFlashcard(Deck deck, Flashcard flashcard) async {
    deck.flashcards.remove(flashcard);
  }

  @override
  Future<void> updateFlashcard(Deck deck, Flashcard flashcard) async {
    final index = deck.flashcards.indexOf(flashcard);
    if (index != -1) {
      deck.flashcards[index] = flashcard;
    }
  }

  @override
  Future<void> updateDeck(Deck deck) async {
    final index = decks.indexWhere((d) => d.id == deck.id);
    if (index != -1) {
      decks[index] = deck;
    }
  }

  @override
  Future<void> deleteDeck(Deck deck) async {
    decks.remove(deck);
  }
}
