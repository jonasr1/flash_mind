class Flashcard {
  final String question;
  final String answer;

  int timesReviewed;
  int reviewStep;
  DateTime nextReviewAt;
  DateTime? lastReviewedAt;

  Flashcard({
    required this.question,
    required this.answer,
    this.timesReviewed = 0,
    this.reviewStep = 0,
    DateTime? nextReviewAt,
    this.lastReviewedAt,
  }) : nextReviewAt = nextReviewAt ?? DateTime.now();
}
