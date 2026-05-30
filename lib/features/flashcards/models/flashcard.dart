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

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'reviewStep': reviewStep,
      'timesReviewed': timesReviewed,
      'nextReviewAt': nextReviewAt.toIso8601String(),
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
      reviewStep: json['reviewStep'] ?? 0,
      timesReviewed: json['timesReviewed'] ?? 0,
      nextReviewAt: json['nextReviewAt'] != null
          ? DateTime.parse(json['nextReviewAt'])
          : null,
      lastReviewedAt: json['lastReviewedAt'] != null
          ? DateTime.parse(json['lastReviewedAt'])
          : null,
    );
  }

  bool get isDue => nextReviewAt.isBefore(DateTime.now());

  bool get isMastered => reviewStep >= 5;

  bool get isInProgress => timesReviewed > 0 && !isMastered;
}
