import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/screens/flashcard_session_screen.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
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

  @override
  Future<void> reviewFlashcard(
    Deck deck,
    Flashcard card,
    ReviewRating rating, {
    int? customXp,
  }) async {
    customXpCalls.add(customXp);
    ratingCalls.add(rating);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('FlashcardSessionScreen Onboarding Tour Tests', () {
    Future<void> pumpFrames(
      WidgetTester tester, {
      int count = 10,
      Duration duration = const Duration(milliseconds: 100),
    }) async {
      for (int i = 0; i < count; i++) {
        await tester.pump(duration);
      }
    }

    testWidgets('Onboarding starts automatically for first study session', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      expect(find.text('Revelar a Resposta'), findsOneWidget);
      expect(find.text('Toque no card para ver a resposta.'), findsOneWidget);
      expect(find.text('Pular'), findsOneWidget);
      expect(find.text('Concluir'), findsOneWidget);
    });

    testWidgets('User can dismiss onboarding via Concluir button', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      expect(find.text('Revelar a Resposta'), findsOneWidget);

      await tester.tap(find.text('Concluir'));
      await pumpFrames(tester);

      expect(find.text('Revelar a Resposta'), findsNothing);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('has_seen_study_tour'), isTrue);
    });

    testWidgets('User can skip onboarding via Pular button', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      expect(find.text('Revelar a Resposta'), findsOneWidget);

      await tester.tap(find.text('Pular'));
      await pumpFrames(tester);

      expect(find.text('Revelar a Resposta'), findsNothing);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('has_seen_study_tour'), isTrue);
    });

    testWidgets('Onboarding does not display if already completed/skipped', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'has_seen_study_tour': true});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      expect(find.text('Revelar a Resposta'), findsNothing);
    });
  });

  group('Flashcard Rating Onboarding Tour Tests', () {
    Future<void> pumpFrames(
      WidgetTester tester, {
      int count = 10,
      Duration duration = const Duration(milliseconds: 100),
    }) async {
      for (int i = 0; i < count; i++) {
        await tester.pump(duration);
      }
    }

    testWidgets('Rating onboarding starts automatically when answer is revealed for the first time', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Study tour completed, rating tour not completed
      SharedPreferences.setMockInitialValues({'has_seen_study_tour': true});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Verify study tour is not shown
      expect(find.text('Revelar a Resposta'), findsNothing);

      // Tap flashcard to show answer
      await tester.tap(find.text('Q1'));
      await tester.pump();
      await tester.idle();
      await tester.pump();
      await pumpFrames(tester);

      // Rating onboarding should appear
      expect(find.text('Avalie sua resposta'), findsOneWidget);
      expect(
        find.text(
          'Escolha a opção que melhor representa o quanto você lembrou da resposta.\n\n'
          'O FlashMind usa essa avaliação para definir quando mostrar este card novamente.\n\n'
          '• Não sabia\n'
          '  Você não conseguiu lembrar da resposta.\n\n'
          '• Difícil\n'
          '  Você lembrou com dificuldade.\n\n'
          '• Fácil\n'
          '  Você lembrou com facilidade.\n\n'
          '💡 Dica: toque novamente no card para voltar à pergunta.',
        ),
        findsOneWidget,
      );
      expect(find.text('Pular'), findsOneWidget);
      expect(find.text('Concluir'), findsOneWidget);
    });

    testWidgets('User can dismiss rating onboarding via Concluir button', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'has_seen_study_tour': true});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Reveal answer
      await tester.tap(find.text('Q1'));
      await tester.pump();
      await tester.idle();
      await tester.pump();
      await pumpFrames(tester);

      expect(find.text('Avalie sua resposta'), findsOneWidget);

      // Tap Concluir
      await tester.tap(find.text('Concluir'));
      await pumpFrames(tester);

      // Verify onboarding tooltip is dismissed
      expect(find.text('Avalie sua resposta'), findsNothing);

      // Verify SharedPreferences state was set to true
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('has_seen_rating_tour'), isTrue);
    });

    testWidgets('User can skip rating onboarding via Pular button', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      SharedPreferences.setMockInitialValues({'has_seen_study_tour': true});

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Reveal answer
      await tester.tap(find.text('Q1'));
      await tester.pump();
      await tester.idle();
      await tester.pump();
      await pumpFrames(tester);

      expect(find.text('Avalie sua resposta'), findsOneWidget);

      // Tap Pular
      await tester.tap(find.text('Pular'));
      await pumpFrames(tester);

      // Verify onboarding tooltip is dismissed
      expect(find.text('Avalie sua resposta'), findsNothing);

      // Verify SharedPreferences state was set to true
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('has_seen_rating_tour'), isTrue);
    });

    testWidgets('Rating onboarding does not display if already completed/skipped', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      SharedPreferences.setMockInitialValues({
        'has_seen_study_tour': true,
        'has_seen_rating_tour': true,
      });

      final now = DateTime.now();
      final dueCard = Flashcard(
        question: 'Q1',
        answer: 'A1',
      )..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final mockDeck = Deck(
        id: '1',
        title: 'Test Deck',
        flashcards: [dueCard],
      );

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: FlashcardSessionScreen(deck: mockDeck),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Reveal answer
      await tester.tap(find.text('Q1'));
      await tester.pump();
      await tester.idle();
      await tester.pump();
      await pumpFrames(tester);

      // Verify showcase tooltip is NOT displayed
      expect(find.text('Avalie sua resposta'), findsNothing);
    });
  });

  group('FlashcardSessionScreen Stable Session Queue Tests', () {
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

    Future<void> tapRating(WidgetTester tester, String label, {bool settle = true}) async {
      final context = tester.element(find.byType(FlashcardSessionScreen));
      ScaffoldMessenger.of(context).clearSnackBars();
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      if (settle) {
        await tester.pumpAndSettle();
      } else {
        await tester.pump();
      }
    }

    testWidgets('Scenario 1: [A, B, C, D] -> A -> Não sabia => [B, C, A, D]', (
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

      // Active card is A. Question 'Q_A' should be visible.
      expect(find.text('Q_A'), findsOneWidget);

      // Tap to reveal answer
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();

      // Tap 'Não sabia'
      await tapRating(tester, 'Não sabia');

      // Queue is now [B, C, A, D]. Next card is B.
      expect(find.text('Q_B'), findsOneWidget);

      // Tap to reveal answer
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil'); // leaves queue

      // Queue is now [C, A, D]. Next card is C.
      expect(find.text('Q_C'), findsOneWidget);

      // Tap to reveal answer
      await tester.tap(find.text('Q_C'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil'); // leaves queue

      // Queue is now [A, D]. Next card is A.
      expect(find.text('Q_A'), findsOneWidget);
    });

    testWidgets('Scenario 2: [A, B] -> A -> Não sabia => [B, A]', (
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

      expect(find.text('Q_A'), findsOneWidget);

      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Queue is now [B, A]. Next card is B.
      expect(find.text('Q_B'), findsOneWidget);

      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil');

      // Queue is now [A]. Next card is A.
      expect(find.text('Q_A'), findsOneWidget);
    });

    testWidgets('Scenario 3: [A] -> A -> Não sabia => [A]', (
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

      expect(find.text('Q_A'), findsOneWidget);

      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Queue is still [A]. Next card is still A.
      expect(find.text('Q_A'), findsOneWidget);
    });

    testWidgets('Scenario 4: Three consecutive "Não sabia" for the same card => removed, no reinsertion', (
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

      // Card A should be permanently removed, queue is empty, completes session.
      // The session completed dialog should be visible.
      expect(find.text('Sessão concluída 🎉'), findsOneWidget);
    });

    testWidgets('Scenario 5: Passing time does not alter queue order', (
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

      expect(find.text('Q_A'), findsOneWidget);

      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();

      // Update cardA's nextReviewAt to past (simulating time passing where cardA becomes due again)
      cardA.nextReviewAt = DateTime.now().subtract(const Duration(seconds: 1));

      await tapRating(tester, 'Fácil');

      // Queue is [B]. Next card is B.
      expect(find.text('Q_B'), findsOneWidget);

      // Tap to flip B.
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();

      // It should still be displaying B's answer/question, not jumped to A.
      expect(find.text('A_B'), findsOneWidget);
    });

    testWidgets('XP Rebalance: Forgot XP awards 5 XP on first exposure, 0 XP subsequently', (
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

      // Exposure 1: A -> Forgot (Awarded 5 XP)
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia', settle: false);

      // Verify customXp call is 5, and XP anim (+5 XP) is shown
      expect(mockReviewService.customXpCalls.last, 5);
      expect(find.text('+5 XP'), findsOneWidget);

      // Dismiss floating XP labels
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Exposure 2: A -> Forgot (Awarded 0 XP)
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Verify customXp call is 0, and no floating XP anim (+0 XP or other) is shown
      expect(mockReviewService.customXpCalls.last, 0);
      expect(find.text('+0 XP'), findsNothing);
      expect(find.text('+5 XP'), findsNothing);

      // Exposure 3: A -> Forgot (Awarded 0 XP, card permanently removed)
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      // Verify customXp call is 0, and no floating XP anim is shown
      expect(mockReviewService.customXpCalls.last, 0);
      expect(find.text('+0 XP'), findsNothing);
      expect(find.text('+5 XP'), findsNothing);

      // Session completes
      expect(find.text('Sessão concluída 🎉'), findsOneWidget);
    });

    testWidgets('XP Rebalance: Difficult and Easy ratings award correct XP and leaves session', (
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

      // Card A -> Difficult (10 XP)
      expect(find.text('Q_A'), findsOneWidget);
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Difícil', settle: false);

      expect(mockReviewService.customXpCalls.last, 10);
      expect(find.text('+10 XP'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Card B -> Easy (15 XP)
      expect(find.text('Q_B'), findsOneWidget);
      await tester.tap(find.text('Q_B'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Fácil', settle: false);

      expect(mockReviewService.customXpCalls.last, 15);
      expect(find.text('+15 XP'), findsOneWidget);
    });

    testWidgets('XP Rebalance: XP tracking resets when a new session starts', (
      WidgetTester tester,
    ) async {
      final now = DateTime.now();
      final cardA = Flashcard(id: 'A', question: 'Q_A', answer: 'A_A')..nextReviewAt = now.subtract(const Duration(minutes: 5));

      final deck = Deck(id: '1', title: 'Test Deck', flashcards: [cardA]);

      final mockReviewService2 = MockReviewService();
      bool useService2 = false;

      // Wrap in MaterialApp with Start button to allow popping cleanly
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppScope(
                      deckService: mockDeckService,
                      userProgressController: mockProgressController as dynamic,
                      reviewService: useService2 ? mockReviewService2 : mockReviewService,
                      child: FlashcardSessionScreen(deck: deck),
                    ),
                  ),
                );
              },
              child: const Text('Start'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Launch Session 1
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      // Exposure 1 of Session 1: A -> Forgot (5 XP)
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      expect(mockReviewService.customXpCalls.last, 5);

      // Exit Session 1
      final context1 = tester.element(find.byType(FlashcardSessionScreen));
      ScaffoldMessenger.of(context1).clearSnackBars();
      await tester.pumpAndSettle();
      Navigator.of(context1).pop();
      await tester.pumpAndSettle();

      // Reset cardA to be due again
      cardA.nextReviewAt = DateTime.now().subtract(const Duration(minutes: 5));
      useService2 = true;

      // Start Session 2 by tapping 'Start' button again
      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      // Exposure 1 of Session 2: A -> Forgot (5 XP again because tracking reset)
      await tester.tap(find.text('Q_A'));
      await tester.pumpAndSettle();
      await tapRating(tester, 'Não sabia');

      expect(mockReviewService2.customXpCalls.last, 5);
    });
  });
}
