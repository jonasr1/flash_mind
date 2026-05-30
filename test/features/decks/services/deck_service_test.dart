import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/repositories/deck_repository.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDeckRepository implements DeckRepository {
  List<Deck> decks = [];

  @override
  Future<List<Deck>> getDecks() async => decks;

  @override
  Future<void> createDeck(Deck deck) async => decks.add(deck);

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
  Future<void> deleteDeck(Deck deck) async {
    decks.remove(deck);
  }
}

void main() {
  late DeckService deckService;
  late MockDeckRepository repository;

  setUp(() {
    repository = MockDeckRepository();
    deckService = DeckService(repository: repository);
  });

  test('deleteDeck removes deck from repository', () async {
    final deck = Deck(title: 'Test Deck', flashcards: []);
    await repository.createDeck(deck);
    expect((await repository.getDecks()).length, 1);

    await deckService.deleteDeck(deck);
    expect((await repository.getDecks()).length, 0);
  });
}
