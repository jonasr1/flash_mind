import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/repositories/in_memory_user_progress_repository.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/core/progress/services/gamification_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/repositories/deck_repository.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/services/spaced_repetition_service.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDeckRepository implements DeckRepository {
  List<Deck> decks = [];

  @override
  Future<List<Deck>> getDecks() async {
    return decks.map((d) => Deck.fromJson(d.toJson())).toList();
  }

  @override
  Future<void> createDeck(Deck deck) async {
    decks.add(Deck.fromJson(deck.toJson()));
  }

  @override
  Future<void> addFlashcard(Deck deck, Flashcard flashcard) async {
    final idx = decks.indexWhere((d) => d.id == deck.id);
    if (idx != -1) {
      decks[idx].flashcards.add(Flashcard.fromJson(flashcard.toJson()));
    }
  }

  @override
  Future<void> deleteFlashcard(Deck deck, Flashcard flashcard) async {
    final idx = decks.indexWhere((d) => d.id == deck.id);
    if (idx != -1) {
      decks[idx].flashcards.removeWhere((f) => f.id == flashcard.id);
    }
  }

  @override
  Future<void> updateFlashcard(Deck deck, Flashcard flashcard) async {
    final idx = decks.indexWhere((d) => d.id == deck.id);
    if (idx != -1) {
      final fidx = decks[idx].flashcards.indexWhere(
        (f) => f.id == flashcard.id,
      );
      if (fidx != -1) {
        decks[idx].flashcards[fidx] = Flashcard.fromJson(flashcard.toJson());
      }
    }
  }

  @override
  Future<void> updateDeck(Deck deck) async {
    final idx = decks.indexWhere((d) => d.id == deck.id);
    if (idx != -1) {
      decks[idx] = Deck.fromJson(deck.toJson());
    }
  }

  @override
  Future<void> deleteDeck(Deck deck) async {
    decks.removeWhere((d) => d.id == deck.id);
  }
}

void main() {
  group('SpacedRepetitionService Test', () {
    late SpacedRepetitionService service;

    setUp(() {
      service = SpacedRepetitionService();
    });

    test(
      'Brand new card starts at step 0 and becomes step 1 after Easy review',
      () {
        final card = Flashcard(question: 'Q', answer: 'A');
        expect(card.reviewStep, 0);
        expect(card.timesReviewed, 0);

        service.reviewCard(card, ReviewRating.easy);

        expect(card.reviewStep, 1);
        expect(card.timesReviewed, 1);
      },
    );

    test(
      'Create new card, serialize/deserialize, review as Easy, check results',
      () {
        // 1. Create card
        final card = Flashcard(question: 'Q2', answer: 'A2');
        expect(card.reviewStep, 0);
        expect(card.timesReviewed, 0);

        // 2. Serialize to JSON (persistence simulation)
        final json = card.toJson();

        // 3. Deserialize (app restart simulation)
        final reloadedCard = Flashcard.fromJson(json);
        expect(reloadedCard.reviewStep, 0);
        expect(reloadedCard.timesReviewed, 0);

        // 4. Review as Easy
        service.reviewCard(reloadedCard, ReviewRating.easy);

        // 5. Verify expectations
        expect(reloadedCard.reviewStep, 1);
        expect(reloadedCard.timesReviewed, 1);

        final expectedNextReview = DateTime.now().add(
          const Duration(minutes: 10),
        );
        expect(
          reloadedCard.nextReviewAt
                  .difference(expectedNextReview)
                  .inSeconds
                  .abs() <
              5,
          isTrue,
        );
      },
    );

    test(
      'Simulate the bug: two reviewCard calls in a row on a new card results in step 2 (1 hour)',
      () {
        final card = Flashcard(question: 'Buggy Card', answer: 'Answer');
        expect(card.reviewStep, 0);

        // Call 1
        service.reviewCard(card, ReviewRating.easy);
        expect(card.reviewStep, 1);
        expect(card.timesReviewed, 1);

        // Call 2
        service.reviewCard(card, ReviewRating.easy);
        expect(card.reviewStep, 2);
        expect(card.timesReviewed, 2);

        final expectedNextReview = DateTime.now().add(const Duration(hours: 1));
        expect(
          card.nextReviewAt.difference(expectedNextReview).inSeconds.abs() < 5,
          isTrue,
        );
      },
    );

    test(
      'Full flow simulation: Create, persistence reload, and review',
      () async {
        // 1. Setup repository and services
        final repository = MockDeckRepository();
        final deckService = DeckService(repository: repository);
        await deckService.init();

        // Create a deck
        final deck = await deckService.createDeck(title: 'Git');

        // 2. Create card (Step 1: "Create new card")
        await deckService.addFlashcard(
          deck: deck,
          question: 'Q3',
          answer: 'A3',
        );

        // Verify it is in cache
        expect(deck.flashcards.length, 1);
        final initialCard = deck.flashcards.first;
        expect(initialCard.reviewStep, 0);

        // 3. Persist and Reload (Step 2: "Restart app")
        final newDeckService = DeckService(repository: repository);
        await newDeckService.init();

        final reloadedDecks = newDeckService.decks;
        final reloadedDeck = reloadedDecks.first;
        final reloadedCard = reloadedDeck.flashcards.first;

        // Verify reloaded initial values
        expect(reloadedCard.reviewStep, 0);
        expect(reloadedCard.timesReviewed, 0);

        // 4. Review immediately (Step 3: "Review card -> Select Easy")
        final progressController = UserProgressController(
          repository: InMemoryUserProgressRepository(),
        );
        await progressController.init();

        final reviewService = ReviewService(
          spacedRepetitionService: service,
          gamificationService: const GamificationService(),
          userProgressController: progressController,
          deckService: newDeckService,
        );

        await reviewService.reviewFlashcard(
          reloadedDeck,
          reloadedCard,
          ReviewRating.easy,
        );

        final finalCard = newDeckService.decks.first.flashcards.first;
        expect(finalCard.reviewStep, 1);
        expect(finalCard.timesReviewed, 1);

        final expectedNextReview = DateTime.now().add(
          const Duration(minutes: 10),
        );
        expect(
          finalCard.nextReviewAt
                  .difference(expectedNextReview)
                  .inSeconds
                  .abs() <
              5,
          isTrue,
        );
      },
    );

    test('new card reviewed as easy goes to 10 minutes', () {
      final card = Flashcard(question: 'Q', answer: 'A');
      final service = SpacedRepetitionService();
      service.reviewCard(card, ReviewRating.easy);
      expect(card.reviewStep, 1);
    });
  });
}
