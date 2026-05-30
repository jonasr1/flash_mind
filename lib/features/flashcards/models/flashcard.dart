class Flashcard {
  String question;
  String answer;

  int reviewStep;
  int timesReviewed;
  DateTime nextReviewAt;
  DateTime? lastReviewedAt;

  Flashcard({
    required this.question,
    required this.answer,
    this.reviewStep = 0,
    this.timesReviewed = 0,
    DateTime? nextReviewAt,
    this.lastReviewedAt,
  }) : nextReviewAt = nextReviewAt ?? DateTime.now();

  bool get isDue => nextReviewAt.isBefore(DateTime.now());

  bool get isMastered => reviewStep >= 5;

  bool get isInProgress => timesReviewed > 0 && !isMastered;
}
