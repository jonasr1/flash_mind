import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/models/user_progress.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/home/screens/home_screen.dart';
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
      const UserProgress(totalXp: 120, streakDays: 1, lastStudyDate: null);

  @override
  void refreshFor(DateTime now) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockReviewService implements ReviewService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('HomeScreen Onboarding Tour Tests', () {
    Future<void> pumpFrames(
      WidgetTester tester, {
      int count = 10,
      Duration duration = const Duration(milliseconds: 100),
    }) async {
      for (int i = 0; i < count; i++) {
        await tester.pump(duration);
      }
    }

    testWidgets('Onboarding starts automatically for new users', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: const HomeScreen(),
          ),
        ),
      );

      // Trigger post frame callback and allow transitions/animations to run
      await tester.pump();
      await pumpFrames(tester);

      expect(
        find.text(
          'Aqui você vê quantos cards estão prontos para revisão neste momento.',
        ),
        findsOneWidget,
      );
      expect(find.text('Pular'), findsOneWidget);
      expect(find.text('Avançar'), findsOneWidget);
    });

    testWidgets('User can advance and skip/finish onboarding', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Step 1: Available Cards statistic
      expect(
        find.text(
          'Aqui você vê quantos cards estão prontos para revisão neste momento.',
        ),
        findsOneWidget,
      );

      // Tap "Avançar" to go to Step 2
      await tester.tap(find.text('Avançar'));
      await pumpFrames(tester);

      // Step 2: Start Studying button
      expect(
        find.text(
          'É por aqui que você inicia suas revisões diárias de flashcards.',
        ),
        findsOneWidget,
      );

      // Tap "Avançar" to go to Step 3
      await tester.tap(find.text('Avançar'));
      await pumpFrames(tester);

      // Step 3: Level Card / progress
      expect(
        find.text('Ganhe XP enquanto estuda e suba de nível com o tempo.'),
        findsOneWidget,
      );
      expect(find.text('Concluir'), findsOneWidget);

      // Tap "Concluir" to complete onboarding
      await tester.tap(find.text('Concluir'));
      await pumpFrames(tester);

      // Verify that onboarding is dismissed
      expect(
        find.text('Ganhe XP enquanto estuda e suba de nível com o tempo.'),
        findsNothing,
      );

      // Verify SharedPreferences state was set to true
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('has_seen_home_tour'), isTrue);
    });

    testWidgets('User can skip onboarding on step 1', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Step 1: Available Cards statistic
      expect(
        find.text(
          'Aqui você vê quantos cards estão prontos para revisão neste momento.',
        ),
        findsOneWidget,
      );

      // Tap "Pular"
      await tester.tap(find.text('Pular'));
      await pumpFrames(tester);

      // Verify that onboarding is dismissed immediately
      expect(
        find.text(
          'Aqui você vê quantos cards estão prontos para revisão neste momento.',
        ),
        findsNothing,
      );

      // Verify SharedPreferences state was set to true
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('has_seen_home_tour'), isTrue);
    });

    testWidgets('Onboarding does not display if already completed/skipped', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({'has_seen_home_tour': true});

      final mockDeckService = MockDeckService();
      final mockProgressController = MockUserProgressController();
      final mockReviewService = MockReviewService();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScope(
            deckService: mockDeckService,
            userProgressController: mockProgressController as dynamic,
            reviewService: mockReviewService as dynamic,
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await pumpFrames(tester);

      // Verify showcase tooltip is NOT displayed
      expect(
        find.text(
          'Aqui você vê quantos cards estão prontos para revisão neste momento.',
        ),
        findsNothing,
      );
      expect(
        find.text(
          'É por aqui que você inicia suas revisões diárias de flashcards.',
        ),
        findsNothing,
      );
      expect(
        find.text('Ganhe XP enquanto estuda e suba de nível com o tempo.'),
        findsNothing,
      );
    });
  });
}
