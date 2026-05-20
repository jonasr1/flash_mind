import 'package:flash_mind/features/decks/models/deck.dart';

class StatsData {
  final int streakDays;
  final int reviewedToday;

  const StatsData({required this.streakDays, required this.reviewedToday});

  factory StatsData.fromDecks({
    required List<Deck> decks,
    required int streakDays,
    required DateTime now,
  }) {
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final reviewedToday = decks.expand((deck) => deck.flashcards).where((card) {
      final lastReviewedAt = card.lastReviewedAt;
      if (lastReviewedAt == null) return false;

      return !lastReviewedAt.isBefore(startOfDay) &&
          lastReviewedAt.isBefore(endOfDay);
    }).length;

    return StatsData(streakDays: streakDays, reviewedToday: reviewedToday);
  }
}
