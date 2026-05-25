import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/review/review_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/decks/widgets/deck_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDeckService implements DeckService {
  bool deleteCalled = false;
  @override
  Future<void> deleteDeck(Deck deck) async {
    deleteCalled = true;
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockUserProgressController extends ChangeNotifier implements UserProgressController {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockReviewService implements ReviewService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('DeckListItem shows confirmation dialog and calls delete', (WidgetTester tester) async {
    final deck = Deck(title: 'Test Deck', flashcards: []);
    final mockDeckService = MockDeckService();
    bool updated = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AppScope(
          deckService: mockDeckService,
          userProgressController: MockUserProgressController() as dynamic,
          reviewService: MockReviewService() as dynamic,
          child: Scaffold(
            body: DeckListItem(
              deck: deck,
              onDeckUpdated: () => updated = true,
            ),
          ),
        ),
      ),
    );

    // Open menu
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    // Tap delete option
    await tester.tap(find.text('Apagar baralho'));
    await tester.pumpAndSettle();

    // Verify dialog
    expect(find.text('Apagar baralho'), findsOneWidget);
    expect(find.text('Deseja apagar "Test Deck"?'), findsOneWidget);

    // Tap confirm
    await tester.tap(find.text('Apagar'));
    await tester.pumpAndSettle();

    // Verify calls
    expect(mockDeckService.deleteCalled, isTrue);
    expect(updated, isTrue);
  });
}
