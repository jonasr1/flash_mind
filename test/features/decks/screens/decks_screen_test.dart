import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/screens/decks_screen.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDeckService extends ChangeNotifier implements DeckService {
  final List<Deck> _decks;
  MockDeckService(this._decks);

  @override
  List<Deck> get decks => _decks;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserProgressController extends ChangeNotifier
    implements UserProgressController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockReviewService implements ReviewService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DecksScreen Onboarding Tour Tests', () {
    Future<void> pumpFrames(
      WidgetTester tester, {
      int count = 10,
      Duration duration = const Duration(milliseconds: 100),
    }) async {
      for (int i = 0; i < count; i++) {
        await tester.pump(duration);
      }
    }

    group('Scenario 1: No decks available', () {
      testWidgets('Highlights create deck button and displays correct tooltip', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        final mockDeckService = MockDeckService([]);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        expect(find.text('Crie seu primeiro baralho'), findsOneWidget);
        expect(
          find.text('Crie um baralho para começar a estudar com flashcards.'),
          findsOneWidget,
        );
        expect(find.text('Pular'), findsOneWidget);
        expect(find.text('Concluir'), findsOneWidget);
      });

      testWidgets('Saves has_seen_decks_tour when completed', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        final mockDeckService = MockDeckService([]);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        await tester.tap(find.text('Concluir'));
        await pumpFrames(tester);

        expect(find.text('Crie seu primeiro baralho'), findsNothing);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('has_seen_decks_tour'), isTrue);
      });

      testWidgets('Saves has_seen_decks_tour when skipped', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        final mockDeckService = MockDeckService([]);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        await tester.tap(find.text('Pular'));
        await pumpFrames(tester);

        expect(find.text('Crie seu primeiro baralho'), findsNothing);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('has_seen_decks_tour'), isTrue);
      });
    });

    group('Scenario 2: At least one deck exists', () {
      testWidgets('Multi-step onboarding flow functions correctly', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        final mockDecks = [
          Deck(
            id: '1',
            title: 'Test Deck 1',
            flashcards: [],
          ),
        ];
        final mockDeckService = MockDeckService(mockDecks);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        // Step 1: Highlights Create Deck button
        expect(find.text('Criar Baralho'), findsOneWidget);
        expect(
          find.text('Crie seus próprios baralhos para organizar os conteúdos que deseja estudar.'),
          findsOneWidget,
        );
        expect(find.text('Pular'), findsOneWidget);
        expect(find.text('Avançar'), findsOneWidget);

        // Advance to Step 2
        await tester.tap(find.text('Avançar'));
        await pumpFrames(tester);

        // Step 2: Highlights first deck card
        expect(find.text('Criar Baralho'), findsNothing);
        expect(find.text('Iniciar Estudos'), findsOneWidget);
        expect(
          find.text('Toque em qualquer baralho para iniciar uma sessão de estudos.'),
          findsOneWidget,
        );
        expect(find.text('Pular'), findsOneWidget);
        expect(find.text('Concluir'), findsOneWidget);

        // Complete the onboarding tour
        await tester.tap(find.text('Concluir'));
        await pumpFrames(tester);

        expect(find.text('Iniciar Estudos'), findsNothing);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('has_seen_decks_tour'), isTrue);
      });

      testWidgets('Saves has_seen_decks_tour when skipped in Step 1', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        final mockDecks = [
          Deck(
            id: '1',
            title: 'Test Deck 1',
            flashcards: [],
          ),
        ];
        final mockDeckService = MockDeckService(mockDecks);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        // Step 1
        expect(find.text('Criar Baralho'), findsOneWidget);

        // Tap Pular
        await tester.tap(find.text('Pular'));
        await pumpFrames(tester);

        expect(find.text('Criar Baralho'), findsNothing);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('has_seen_decks_tour'), isTrue);
      });
    });

    group('Returning users who already completed the onboarding', () {
      testWidgets('Does not display onboarding showcase for empty deck list', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({'has_seen_decks_tour': true});

        final mockDeckService = MockDeckService([]);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        expect(find.text('Crie seu primeiro baralho'), findsNothing);
      });

      testWidgets('Does not display onboarding showcase for non-empty deck list', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({'has_seen_decks_tour': true});

        final mockDecks = [
          Deck(
            id: '1',
            title: 'Test Deck 1',
            flashcards: [],
          ),
        ];
        final mockDeckService = MockDeckService(mockDecks);
        final mockProgressController = MockUserProgressController();
        final mockReviewService = MockReviewService();

        await tester.pumpWidget(
          MaterialApp(
            home: AppScope(
              deckService: mockDeckService,
              userProgressController: mockProgressController as dynamic,
              reviewService: mockReviewService as dynamic,
              child: const DecksScreen(),
            ),
          ),
        );

        await tester.pump();
        await pumpFrames(tester);

        expect(find.text('Criar Baralho'), findsNothing);
        expect(find.text('Iniciar Estudos'), findsNothing);
      });
    });
  });
}
