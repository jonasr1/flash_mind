import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/services/gamification_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/services/deck_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/services/spaced_repetition_service.dart';

class ReviewService {
  final SpacedRepetitionService _spacedRepetitionService;
  final GamificationService _gamificationService;
  final UserProgressController _userProgressController;
  final DeckService _deckService;

  ReviewService({
    required SpacedRepetitionService spacedRepetitionService,
    required GamificationService gamificationService,
    required UserProgressController userProgressController,
    required DeckService deckService,
  })  : _spacedRepetitionService = spacedRepetitionService,
        _gamificationService = gamificationService,
        _userProgressController = userProgressController,
        _deckService = deckService;

  Future<void> reviewFlashcard(Deck deck, Flashcard card, ReviewRating rating) async {
    _spacedRepetitionService.reviewCard(card, rating);

    await _deckService.updateFlashcard(
      deck: deck,
      flashcard: card,
      question: card.question,
      answer: card.answer,
    );

    final updatedProgress = _gamificationService.applyReview(
      _userProgressController.progress,
      rating,
      now: DateTime.now(),
    );
    _userProgressController.setProgress(updatedProgress);
  }
}
