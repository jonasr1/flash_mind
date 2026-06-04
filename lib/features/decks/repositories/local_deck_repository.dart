import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'deck_repository.dart';
import '../data/decks_data.dart' as default_data;

class LocalDeckRepository implements DeckRepository {
  static const String _key = 'flash_mind_decks';
  final SharedPreferences _prefs;

  LocalDeckRepository(this._prefs);

  @override
  Future<List<Deck>> getDecks() async {
    final String? decksJson = _prefs.getString(_key);
    if (decksJson == null) {
      final List<Deck> decks = default_data.decks;
      await _saveDecks(decks);
      return decks;
    }

    final List<dynamic> decoded = jsonDecode(decksJson);
    return decoded.map((item) => Deck.fromJson(item)).toList();
  }

  @override
  Future<void> createDeck(Deck deck) async {
    final List<Deck> decks = await getDecks();
    decks.add(deck);
    await _saveDecks(decks);
  }

  @override
  Future<void> addFlashcard(Deck deck, Flashcard flashcard) async {
    final List<Deck> decks = await getDecks();
    final deckIndex = decks.indexWhere((d) => d.id == deck.id);
    if (deckIndex != -1) {
      decks[deckIndex].flashcards.add(flashcard);
      await _saveDecks(decks);
    }
  }

  @override
  Future<void> deleteFlashcard(Deck deck, Flashcard flashcard) async {
    final List<Deck> decks = await getDecks();
    final deckIndex = decks.indexWhere((d) => d.id == deck.id);
    if (deckIndex != -1) {
      decks[deckIndex].flashcards.removeWhere((f) => 
          f.question == flashcard.question && f.answer == flashcard.answer);
      await _saveDecks(decks);
    }
  }

  @override
  Future<void> updateFlashcard(Deck deck, Flashcard flashcard) async {
    final List<Deck> decks = await getDecks();
    final deckIndex = decks.indexWhere((d) => d.id == deck.id);
    if (deckIndex != -1) {
      final cardIndex = decks[deckIndex].flashcards.indexWhere((f) => 
          f.question == flashcard.question && f.answer == flashcard.answer);
      if (cardIndex != -1) {
        decks[deckIndex].flashcards[cardIndex] = flashcard;
        await _saveDecks(decks);
      }
    }
  }

  @override
  Future<void> updateDeck(Deck deck) async {
    final List<Deck> decks = await getDecks();
    final index = decks.indexWhere((d) => d.id == deck.id);
    if (index != -1) {
      decks[index] = deck;
      await _saveDecks(decks);
    }
  }

  @override
  Future<void> deleteDeck(Deck deck) async {
    final List<Deck> decks = await getDecks();
    decks.removeWhere((d) => d.id == deck.id);
    await _saveDecks(decks);
  }

  Future<void> _saveDecks(List<Deck> decks) async {
    final String encoded = jsonEncode(decks.map((d) => d.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
