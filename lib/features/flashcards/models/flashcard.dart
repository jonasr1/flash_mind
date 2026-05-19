class Flashcard {
  final String question;
  final String answer;

  int timesReviewed;
  int reviewStep;
  DateTime nextReviewAt;

  Flashcard({
    required this.question,
    required this.answer,
    this.timesReviewed = 0,
    this.reviewStep = 0,
    DateTime? nextReviewAt,
  }) : nextReviewAt = nextReviewAt ?? DateTime.now();
}
