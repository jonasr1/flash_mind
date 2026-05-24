import '../models/deck.dart';

abstract class DeckRepository {
  Future<List<Deck>> getDecks();

  Future<void> createDeck(Deck deck);
}
