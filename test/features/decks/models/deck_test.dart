import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reviewedCards counts only cards scheduled for the future', () {
    final now = DateTime.now();
    final deck = Deck(
      title: 'Test Deck',
      flashcards: [
        Flashcard(
          question: 'Question A',
          answer: 'Answer A',
          nextReviewAt: now.add(const Duration(minutes: 10)),
        ),
        Flashcard(
          question: 'Question B',
          answer: 'Answer B',
          nextReviewAt: now.add(const Duration(minutes: 20)),
        ),
      ],
    );

    expect(deck.totalCards, 2);
    expect(deck.reviewedCards, 2);
    expect(deck.progress, 1);
  });

  test('reviewedCards excludes cards due now or in the past', () {
    final now = DateTime.now();
    final deck = Deck(
      title: 'Test Deck',
      flashcards: [
        Flashcard(
          question: 'Question A',
          answer: 'Answer A',
          nextReviewAt: now.subtract(const Duration(minutes: 1)),
        ),
        Flashcard(
          question: 'Question B',
          answer: 'Answer B',
          nextReviewAt: now.add(const Duration(minutes: 20)),
        ),
      ],
    );

    expect(deck.reviewedCards, 1);
    expect(deck.progress, 0.5);
  });

  test('reviewedCards is zero when all cards are due', () {
    final now = DateTime.now();
    final deck = Deck(
      title: 'Test Deck',
      flashcards: [
        Flashcard(
          question: 'Question A',
          answer: 'Answer A',
          nextReviewAt: now,
        ),
        Flashcard(
          question: 'Question B',
          answer: 'Answer B',
          nextReviewAt: now.subtract(const Duration(minutes: 1)),
        ),
      ],
    );

    expect(deck.reviewedCards, 0);
    expect(deck.progress, 0);
  });
}
