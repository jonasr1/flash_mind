import '../models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

abstract class DeckRepository {
  Future<List<Deck>> getDecks();

  Future<void> createDeck(Deck deck);

  Future<void> addFlashcard(Deck deck, Flashcard flashcard);

  Future<void> deleteFlashcard(Deck deck, Flashcard flashcard);

  Future<void> updateFlashcard(Deck deck, Flashcard flashcard);

  Future<void> updateDeck(Deck deck);

  Future<void> deleteDeck(Deck deck);
}
