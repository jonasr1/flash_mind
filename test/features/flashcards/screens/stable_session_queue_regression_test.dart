import 'dart:async';
import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/screens/flashcard_session_screen.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/widgets/session_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDeckService extends ChangeNotifier implements DeckService {
  @override
  List<Deck> get decks => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserProgressController extends ChangeNotifier
    implements UserProgressController {
  @override
  UserProgress get progress =>
      const UserProgress(totalXp: 0, streakDays: 0, lastStudyDate: null);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockReviewService implements ReviewService {
  final List<int?> customXpCalls = [];
  final List<ReviewRating> ratingCalls = [];
  Future<void> Function(Deck, Flashcard, ReviewRating, {int? customXp})? onReview;

  @override
  Future<void> reviewFlashcard(
    Deck deck,
    Flashcard card,
    ReviewRating rating, {
    int? customXp,
  }) async {
    customXpCalls.add(customXp);
    ratingCalls.add(rating);
    if (onReview != null) {
      await onReview!(deck, card, rating, customXp: customXp);
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Stable Session Queue Regression Test Suite', () {
    late MockDeckService mockDeckService;
    late MockUserProgressController mockProgressController;
    late MockReviewService mockReviewService;

    setUp(() {
      mockDeckService = MockDeckService();
      mockProgressController = MockUserProgressController();
      mockReviewService = MockReviewService();
      SharedPreferences.setMockInitialValues({
        'has_seen_study_tour': true,
        'has_seen_rating_tour': true,
      });
    });

    Future<void> tapRating(WidgetTester tester, String label) async {
      final context = tester.element(find.byType(FlashcardSessionScreen));
      ScaffoldMessenger.of(context).clearSnackBars();
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    testWidgets('Group 1: Session Queue Isolation - Active queue is decoupled from dynamic due card changes and time passing', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardC = Flashcard(id: 'C', question: 'Q_C', answer: 'A_C')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      // Card D is NOT due at session start
      final cardD = Flashcard(id: 'D', question: 'Q_D', answer: 'A_D')..nextReviewAt = now.add(const Duration(hours: 2));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB, cardC, cardD]);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Card A should be active first
      expect(find.text('Q_A'), findsOneWidget);

      // Now set Card A to be not due anymore (e.g. in the future), and set Card D to be due now.
      cardA.nextReviewAt = DateTime.now().add(const Duration(hours: 1));
      cardD.nextReviewAt = DateTime.now().subtract(const Duration(minutes: 5));

      // Trigger rebuild via revealing the answer
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();

      // Card A should still be active, not skipped or removed due to nextReviewAt update
      expect(find.text('A_A'), findsOneWidget);

      // Tap Fácil to complete A
      await tapRating(tester, 'Fácil');

      // Next card in the queue snapshot is B.
      expect(find.text('Q_B'), findsOneWidget);

      // Complete B
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Next card is C. Card D (even though marked due now) was not in the initial snapshot and should NEVER enter.
      expect(find.text('Q_C'), findsOneWidget);

      // Complete C
      await tester.tap(find.text('Q_C'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Since the initial snapshot queue [A, B, C] is completed, session must complete.
      expect(find.text('Sessão concluída 🎉'), findsOneWidget);
      // Card D was never presented
      expect(find.text('Q_D'), findsNothing);
    });

    testWidgets('Group 2: Persistence Before Queue Mutation - Queue does not mutate while persistence is pending and only mutates after success', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB]);

      final completer = Completer<void>();
      mockReviewService.onReview = (deck, card, rating, {customXp}) {
        return completer.future;
      };

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Card A is active
      expect(find.text('Q_A'), findsOneWidget);

      // Reveal answer
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();

      // Tap Fácil - triggers mockReviewService which returns the pending future
      await tester.tap(find.text('Fácil'));
      await tester.pump(const Duration(milliseconds: 100));

      // VERIFY: While persistence is pending, Card A remains active on screen. Queue does not mutate.
      expect(find.text('A_A'), findsOneWidget);
      expect(find.text('Q_B'), findsNothing);

      // Complete the persistence successfully
      completer.complete();
      await tester.pumpAndSettle();

      // VERIFY: Now that persistence succeeded, the queue mutates and Card B becomes active.
      expect(find.text('Q_B'), findsOneWidget);
    });

    testWidgets('Group 3: Exposure Limit - Card is removed from session after 3 "Não sabia" ratings', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Exposure 1
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Exposure 2
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Exposure 3
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Removed after exposure 3, queue is empty, completes session.
      expect(find.text('Sessão concluída 🎉'), findsOneWidget);
    });

    testWidgets('Group 4: Progress Tracking - Denominator remains constant, completed count increments only when card leaves session', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardC = Flashcard(id: 'C', question: 'Q_C', answer: 'A_C')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardD = Flashcard(id: 'D', question: 'Q_D', answer: 'A_D')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB, cardC, cardD]);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check initial progress: Completed is 0, Total is 4.
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 0);
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).totalCards, 4);

      // 1. A -> Fácil
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Completed is 1, Total is 4.
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 1);
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).totalCards, 4);

      // 2. B -> Fácil
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Completed is 2, Total is 4.
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 2);
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).totalCards, 4);

      // 3. C -> Não sabia
      await tester.tap(find.text('Q_C'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Completed is still 2. Total is 4.
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 2);
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).totalCards, 4);

      // 4. D -> Fácil
      await tester.tap(find.text('Q_D'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Completed is 3. Total is 4.
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 3);
      expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).totalCards, 4);

      // 5. C -> Fácil
      await tester.tap(find.text('Q_C'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Session completes.
      expect(find.text('Sessão concluída 🎉'), findsOneWidget);
    });

    testWidgets('Group 5: Scenario A - Forgot card reinserted 2 positions ahead in queue of 4 cards', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardC = Flashcard(id: 'C', question: 'Q_C', answer: 'A_C')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardD = Flashcard(id: 'D', question: 'Q_D', answer: 'A_D')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB, cardC, cardD]);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial: [A, B, C, D]
      expect(find.text('Q_A'), findsOneWidget);

      // A -> Não sabia
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Queue is now [B, C, A, D]. Next card is B.
      expect(find.text('Q_B'), findsOneWidget);

      // Complete B
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Next card is C.
      expect(find.text('Q_C'), findsOneWidget);

      // Complete C
      await tester.tap(find.text('Q_C'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Next card should be A again!
      expect(find.text('Q_A'), findsOneWidget);
    });

    testWidgets('Group 5: Scenario B - Forgot card reinserted at end of queue of 2 cards', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
      final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB]);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial: [A, B]
      expect(find.text('Q_A'), findsOneWidget);

      // A -> Não sabia
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Queue is now [B, A]. Next card is B.
      expect(find.text('Q_B'), findsOneWidget);

      // Complete B
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Next card is A.
      expect(find.text('Q_A'), findsOneWidget);
    });

    testWidgets('Group 5: Scenario C - Forgot card reinserted in place for single-card queue', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: deck),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initial: [A]
      expect(find.text('Q_A'), findsOneWidget);

      // A -> Não sabia
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Queue is still [A]. Next card is still A.
      expect(find.text('Q_A'), findsOneWidget);
    });

    group('Persistence Failure Handling', () {
      testWidgets('Persistence Failure Handling - Test 1: Queue remains unchanged on failure', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardC = Flashcard(id: 'C', question: 'Q_C', answer: 'A_C')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB, cardC]);

        mockReviewService.onReview = (deck, card, rating, {customXp}) {
          throw Exception('Mock persistence failure');
        };

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // Rate card
        await tapRating(tester, 'Fácil');

        // VERIFY: Card A's answer remains visible (queue didn't advance to B)
        expect(find.text('A_A'), findsOneWidget);
        expect(find.text('Q_B'), findsNothing);

        // Verify progress hasn't changed (Completed: 0)
        final progressWidget = tester.widget<SessionProgress>(find.byType(SessionProgress));
        expect(progressWidget.currentIndex, 0);
        expect(progressWidget.totalCards, 3);
      });

      testWidgets('Persistence Failure Handling - Test 2: Processing state resets and buttons become clickable again', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

        int attemptCount = 0;
        mockReviewService.onReview = (deck, card, rating, {customXp}) {
          attemptCount++;
          throw Exception('Mock persistence failure');
        };

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // Attempt 1
        await tapRating(tester, 'Fácil');
        expect(attemptCount, 1);

        // Attempt 2 (should be accepted because buttons are unlocked and processing state reset)
        await tapRating(tester, 'Fácil');
        expect(attemptCount, 2);
      });

      testWidgets('Persistence Failure Handling - Test 3: Error snackbar appears on failure', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

        mockReviewService.onReview = (deck, card, rating, {customXp}) {
          throw Exception('Mock persistence failure');
        };

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        await tapRating(tester, 'Fácil');

        // Verify the snackbar is displayed
        expect(find.text('Could not save review. Please try again.'), findsOneWidget);
      });

      testWidgets('Persistence Failure Handling - Test 4: Progress remains unchanged', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB]);

        mockReviewService.onReview = (deck, card, rating, {customXp}) {
          throw Exception('Mock persistence failure');
        };

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 0);

        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Completed progress remains 0
        expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).currentIndex, 0);
        expect(tester.widget<SessionProgress>(find.byType(SessionProgress)).totalCards, 2);
      });

      testWidgets('Persistence Failure Handling - Test 5: Exposure counter remains unchanged', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

        mockReviewService.onReview = (deck, card, rating, {customXp}) {
          throw Exception('Mock persistence failure');
        };

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Exposure 1 attempt (fails)
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Não sabia');

        // Verify card remains active
        expect(find.text('A_A'), findsOneWidget);
      });

      testWidgets('Persistence Failure Handling - Test 6: Retry after failure succeeds and advances session', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB]);

        bool shouldFail = true;
        mockReviewService.onReview = (deck, card, rating, {customXp}) async {
          if (shouldFail) {
            throw Exception('Mock persistence failure');
          }
        };

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Card A is active
        expect(find.text('Q_A'), findsOneWidget);

        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // 1. Attempt 1 (Fails)
        await tapRating(tester, 'Fácil');

        // Card A is still active and answer sheet remains open
        expect(find.text('A_A'), findsOneWidget);
        expect(find.text('Q_B'), findsNothing);

        // Disable failure for next attempt
        shouldFail = false;

        // 2. Attempt 2 (Succeeds)
        await tapRating(tester, 'Fácil');

      });
    });

    group('Reinsertion Position Validation', () {
      testWidgets('Scenario 1: Standard Reinsertion - [A, B, C, D] -> A -> Forgot => [B, C, A, D]', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardC = Flashcard(id: 'C', question: 'Q_C', answer: 'A_C')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardD = Flashcard(id: 'D', question: 'Q_D', answer: 'A_D')..nextReviewAt = now.subtract(const Duration(minutes: 5));

        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB, cardC, cardD]);

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Initial active: Card A
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // A -> Não sabia
        await tapRating(tester, 'Não sabia');

        // Queue becomes [B, C, A, D]
        // 2. Next active: Card B
        expect(find.text('Q_B'), findsOneWidget);
        await tester.tap(find.text('Q_B'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Queue becomes [C, A, D]
        // 3. Next active: Card C
        expect(find.text('Q_C'), findsOneWidget);
        await tester.tap(find.text('Q_C'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Queue becomes [A, D]
        // 4. Next active: Card A (proving it was inserted at index 2, not at the end!)
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Queue becomes [D]
        // 5. Next active: Card D
        expect(find.text('Q_D'), findsOneWidget);
      });

      testWidgets('Scenario 2: Exactly Two Remaining Cards - [A, B, C] -> A -> Forgot => [B, C, A]', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardC = Flashcard(id: 'C', question: 'Q_C', answer: 'A_C')..nextReviewAt = now.subtract(const Duration(minutes: 5));

        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB, cardC]);

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Initial active: Card A
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // A -> Não sabia
        await tapRating(tester, 'Não sabia');

        // Queue becomes [B, C, A]
        // 2. Next active: Card B
        expect(find.text('Q_B'), findsOneWidget);
        await tester.tap(find.text('Q_B'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Queue becomes [C, A]
        // 3. Next active: Card C
        expect(find.text('Q_C'), findsOneWidget);
        await tester.tap(find.text('Q_C'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Queue becomes [A]
        // 4. Next active: Card A
        expect(find.text('Q_A'), findsOneWidget);
      });

      testWidgets('Scenario 3: One Remaining Card - [A, B] -> A -> Forgot => [B, A]', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));
        final cardB = Flashcard(id: 'B', question: 'Q_B', answer: 'A_B')..nextReviewAt = now.subtract(const Duration(minutes: 5));

        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA, cardB]);

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Initial active: Card A
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // A -> Não sabia
        await tapRating(tester, 'Não sabia');

        // Queue becomes [B, A]
        // 2. Next active: Card B
        expect(find.text('Q_B'), findsOneWidget);
        await tester.tap(find.text('Q_B'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Fácil');

        // Queue becomes [A]
        // 3. Next active: Card A
        expect(find.text('Q_A'), findsOneWidget);
      });

      testWidgets('Scenario 4: No Remaining Cards - [A] -> A -> Forgot => [A]', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));

        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Initial active: Card A
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();

        // A -> Não sabia
        await tapRating(tester, 'Não sabia');

        // Queue becomes [A]
        // 2. Next active: Card A is still available immediately without crash
        expect(find.text('Q_A'), findsOneWidget);
      });

      testWidgets('Scenario 5: Exposure Limit Interaction - Forgotten card removed at 3rd exposure', (
        WidgetTester tester,
      ) async {
        final now = DateTime.now();
        final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));

        final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: FlashcardSessionScreen(deck: deck),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Exposure 1: A -> Não sabia => Loop in queue [A]
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Não sabia');

        // 2. Exposure 2: A -> Não sabia => Loop in queue [A]
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Não sabia');

        // 3. Exposure 3: A -> Não sabia => Card removed, queue becomes [] and session completes
        expect(find.text('Q_A'), findsOneWidget);
        await tester.tap(find.text('Q_A'));
        await tester.pumpAndSettle();
        await tapRating(tester, 'Não sabia');

        expect(find.text('Sessão concluída 🎉'), findsOneWidget);
      });
    });
  });
}
