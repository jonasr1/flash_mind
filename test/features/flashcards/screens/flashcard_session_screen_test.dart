import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/screens/flashcard_session_screen.dart';
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
          'Escolha a opção que melhor representa o quanto você lembrou da resposta. O FlashMind usa essa avaliação para definir quando mostrar este card novamente.\n\nNão sabia: Você não conseguiu lembrar da resposta.\nDifícil: Você lembrou com dificuldade.\nFácil: Você lembrou com facilidade.',
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
}
