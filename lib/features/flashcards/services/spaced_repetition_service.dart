import '../models/flashcard.dart';
import '../models/review_rating.dart';

class SpacedRepetitionService {
  static const reviewIntervals = [
    Duration(minutes: 10),
    Duration(hours: 1),
    Duration(hours: 6),
    Duration(days: 1),
    Duration(days: 3),
    Duration(days: 7),
    Duration(days: 15),
    Duration(days: 30),
  ];

  void reviewCard(Flashcard card, ReviewRating rating) {
    card.timesReviewed++;

    switch (rating) {
      case ReviewRating.forgot:
        card.reviewStep = 0;
        break;

      case ReviewRating.difficult:
        if (card.reviewStep > 0) {
          card.reviewStep--;
        }
        break;

      case ReviewRating.easy:
        if (card.reviewStep < reviewIntervals.length - 1) {
          card.reviewStep++;
        }
        break;
    }

    card.nextReviewAt = DateTime.now().add(reviewIntervals[card.reviewStep]);
  }
}
