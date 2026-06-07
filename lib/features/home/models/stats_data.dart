import 'package:flash_mind/features/decks/models/deck.dart';

class StatsData {
  final int streakDays;
  final int uniqueCardsReviewedToday;
  final int reviewsToday;
  final int availableCards;

  const StatsData({
    required this.streakDays,
    required this.uniqueCardsReviewedToday,
    required this.reviewsToday,
    required this.availableCards,
  });

  factory StatsData.fromDecks({
    required List<Deck> decks,
    required int streakDays,
    required int reviewsToday,
    required DateTime now,
  }) {
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final allCards = decks.expand((deck) => deck.flashcards).toList();

    final uniqueCardsReviewedToday = allCards.where((card) {
      final lastReviewedAt = card.lastReviewedAt;
      if (lastReviewedAt == null) return false;

      return !lastReviewedAt.isBefore(startOfDay) &&
          lastReviewedAt.isBefore(endOfDay);
    }).length;

    final availableCards =
        allCards.where((card) => card.nextReviewAt.isBefore(now)).length;

    return StatsData(
      streakDays: streakDays,
      uniqueCardsReviewedToday: uniqueCardsReviewedToday,
      reviewsToday: reviewsToday,
      availableCards: availableCards,
    );
  }
}
