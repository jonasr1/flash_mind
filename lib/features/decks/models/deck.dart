class Deck {
  final String title;
  final int totalCards;
  final int reviewedCards;

  const Deck({
    required this.title,
    required this.totalCards,
    required this.reviewedCards,
  });

  double get progress {
    if (totalCards == 0) return 0;
    return reviewedCards / totalCards;
  }
}