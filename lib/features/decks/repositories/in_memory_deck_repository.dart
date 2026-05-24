import '../data/decks_data.dart';
import '../models/deck.dart';
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
}
