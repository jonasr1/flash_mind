import 'package:flash_mind/core/progress/controllers/user_progress_controller.dart';
import 'package:flash_mind/core/progress/services/gamification_service.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/services/spaced_repetition_service.dart';

class ReviewService {
  final SpacedRepetitionService _spacedRepetitionService;
  final GamificationService _gamificationService;
  final UserProgressController _userProgressController;

  ReviewService({
    required SpacedRepetitionService spacedRepetitionService,
    required GamificationService gamificationService,
    required UserProgressController userProgressController,
  })  : _spacedRepetitionService = spacedRepetitionService,
        _gamificationService = gamificationService,
        _userProgressController = userProgressController;

  void reviewFlashcard(Flashcard card, ReviewRating rating) {
    _spacedRepetitionService.reviewCard(card, rating);

    final updatedProgress = _gamificationService.applyReview(
      _userProgressController.progress,
      rating,
      now: DateTime.now(),
    );
    _userProgressController.setProgress(updatedProgress);
  }
}
