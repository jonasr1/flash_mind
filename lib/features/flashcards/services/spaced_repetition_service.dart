import 'dart:math';

import '../models/flashcard.dart';
import '../models/review_rating.dart';

class SpacedRepetitionService {
static const reviewIntervals = [
  Duration(minutes: 1),
  Duration(minutes: 5),
  Duration(minutes: 15),
  Duration(hours: 1),
  Duration(hours: 6),
  Duration(days: 1),
  Duration(days: 3),
  Duration(days: 7),
  Duration(days: 15),
  Duration(days: 30),
];

  void reviewCard(Flashcard card, ReviewRating rating) {
    // ignore: avoid_print
    print(
      '[BEFORE] '
      'card=${card.question} '
      'step=${card.reviewStep} '
      'timesReviewed=${card.timesReviewed} '
      'rating=$rating',
    );

    card.timesReviewed++;
    card.lastReviewedAt = DateTime.now();

    switch (rating) {
      case ReviewRating.forgot:
        card.reviewStep = 0;
        break;

      case ReviewRating.difficult:
        card.reviewStep = max(0, card.reviewStep - 2);
        break;

      case ReviewRating.easy:
        if (card.reviewStep < reviewIntervals.length - 1) {
          card.reviewStep++;
        }
        break;
    }

    card.nextReviewAt = DateTime.now().add(reviewIntervals[card.reviewStep]);

    // ignore: avoid_print
    print(
      '[AFTER] '
      'step=${card.reviewStep} '
      'timesReviewed=${card.timesReviewed} '
      'next=${card.nextReviewAt}',
    );
  }
}
