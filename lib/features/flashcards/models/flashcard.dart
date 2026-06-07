class Flashcard {
  final String id;
  String question;
  String answer;

  int reviewStep;
  int timesReviewed;
  DateTime nextReviewAt;
  DateTime? lastReviewedAt;

  Flashcard({
    String? id,
    required this.question,
    required this.answer,
    this.reviewStep = 0,
    this.timesReviewed = 0,
    DateTime? nextReviewAt,
    this.lastReviewedAt,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        nextReviewAt = nextReviewAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      id: json['id'],
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

  Flashcard copyWith({
    String? question,
    String? answer,
    int? reviewStep,
    int? timesReviewed,
    DateTime? nextReviewAt,
    DateTime? lastReviewedAt,
  }) {
    return Flashcard(
      id: id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      reviewStep: reviewStep ?? this.reviewStep,
      timesReviewed: timesReviewed ?? this.timesReviewed,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }
}
