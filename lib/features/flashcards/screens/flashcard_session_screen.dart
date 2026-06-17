import 'dart:async';
import 'package:flash_mind/core/progress/services/gamification_service.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/flashcard_achievement.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/utils/review_utils.dart';
import 'package:flash_mind/features/flashcards/widgets/achievement_banner.dart';
import 'package:flash_mind/features/flashcards/widgets/answer_buttons.dart';
import 'package:flash_mind/features/flashcards/widgets/empty_review_state.dart';
import 'package:flash_mind/features/flashcards/widgets/session_header.dart';
import 'package:flash_mind/features/flashcards/widgets/session_progress.dart';
import 'package:flash_mind/features/flashcards/widgets/xp_gain_label.dart';
import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import '../widgets/flashcard_view.dart';

class FlashcardSessionScreen extends StatefulWidget {
  final Deck deck;

  const FlashcardSessionScreen({super.key, required this.deck});

  @override
  State<FlashcardSessionScreen> createState() => _FlashcardSessionScreenState();
}

class XpGainData {
  final Key key;
  final int xp;
  XpGainData(this.key, this.xp);
}

class _FlashcardSessionScreenState extends State<FlashcardSessionScreen> {
  bool isAnswerVisible = false;
  int currentIndex = 0;
  FlashcardAchievement? currentAchievement;
  final List<XpGainData> _xpGains = [];

  bool _isProcessingReview = false;

  List<Flashcard> _getDueFlashcards(DateTime now) {
    return widget.deck.flashcards
        .where((card) => card.nextReviewAt.isBefore(now))
        .toList();
  }

  int _normalizeIndex(int index, int length) {
    if (length <= 0) return 0;
    if (index < 0) return 0;
    if (index >= length) return length - 1;
    return index;
  }

  void _showAchievement(FlashcardAchievement achievement) {
    setState(() {
      currentAchievement = achievement;
    });
  }

  Future<void> reviewCurrentFlashcard(ReviewRating rating) async {
    if (_isProcessingReview) return;

    final currentDueFlashcards = _getDueFlashcards(DateTime.now());
    if (currentDueFlashcards.isEmpty) return;

    final safeCurrentIndex = _normalizeIndex(
      currentIndex,
      currentDueFlashcards.length,
    );
    final currentCard = currentDueFlashcards[safeCurrentIndex];
    var shouldShowSessionCompletedDialog = false;

    final progressController = AppScope.of(context).userProgressController;
    final oldProgress = progressController.progress;

    // 0. XP Gain Feedback (Internal trigger)
    const gamificationService = GamificationService();
    final xpGained = gamificationService.xpForRating(rating);

    setState(() {
      _isProcessingReview = true;
      isAnswerVisible = false;
    });

    try {
      await AppScope.of(
        context,
      ).reviewService.reviewFlashcard(widget.deck, currentCard, rating);

      if (!mounted) return;

      setState(() {
        _xpGains.add(XpGainData(UniqueKey(), xpGained));
      });

      final newProgress = progressController.progress;

      // 1. Operational Feedback (SnackBar)
      final nextReviewMessage = formatNextReview(currentCard.nextReviewAt);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ Revisão registrada\nPróxima revisão $nextReviewMessage',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // 2. Achievement Feedback (Banner)
      FlashcardAchievement? achievement;

      if (newProgress.title != oldProgress.title) {
        achievement = FlashcardAchievement(
          type: AchievementType.rank,
          message: '🏅 Novo rank desbloqueado: ${newProgress.title}',
        );
      } else if (newProgress.level > oldProgress.level) {
        achievement = FlashcardAchievement(
          type: AchievementType.level,
          message: '⭐ Nível ${newProgress.level} alcançado',
        );
      } else if (newProgress.bestStreak > oldProgress.bestStreak) {
        final daysLabel = newProgress.bestStreak == 1 ? 'dia' : 'dias';
        achievement = FlashcardAchievement(
          type: AchievementType.bestStreak,
          message:
              '🏆 Nova melhor sequência: ${newProgress.bestStreak} $daysLabel',
        );
      } else if (newProgress.streakDays > oldProgress.streakDays) {
        final daysLabel = newProgress.streakDays == 1 ? 'dia' : 'dias';
        achievement = FlashcardAchievement(
          type: AchievementType.streak,
          message: '🔥 Ofensiva: ${newProgress.streakDays} $daysLabel',
        );
      } else if (newProgress.combo > oldProgress.combo) {
        final milestones = [5, 10, 25, 50, 100, 250, 500];
        if (milestones.contains(newProgress.combo)) {
          achievement = FlashcardAchievement(
            type: AchievementType.combo,
            message: '🔥 Combo x${newProgress.combo}',
          );
        }
      }

      if (achievement != null) {
        _showAchievement(achievement);
      }

      setState(() {
        final updatedDueFlashcards = _getDueFlashcards(DateTime.now());
        shouldShowSessionCompletedDialog = updatedDueFlashcards.isEmpty;

        currentIndex = _normalizeIndex(
          safeCurrentIndex,
          updatedDueFlashcards.length,
        );
      });

      if (shouldShowSessionCompletedDialog) {
        showSessionCompletedDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingReview = false;
        });
      }
    }
  }

  void showSessionCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sessão concluída 🎉'),
          content: const Text(
            'Você revisou todos os flashcards deste baralho.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dialog

                if (mounted) {
                  Navigator.of(this.context).pop();
                }
              },
              child: const Text('Voltar'),
            ),
          ],
        );
      },
    );
  }

  void toggleAnswer() {
    if (_isProcessingReview) return;

    setState(() {
      isAnswerVisible = !isAnswerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dueFlashcards = _getDueFlashcards(DateTime.now());
    final safeCurrentIndex = _normalizeIndex(
      currentIndex,
      dueFlashcards.length,
    );
    final currentFlashcard = dueFlashcards.isEmpty
        ? null
        : dueFlashcards[safeCurrentIndex];
    final progressController = AppScope.of(context).userProgressController;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SessionHeader(deckTitle: widget.deck.title),
                  const SizedBox(height: 12),
                  if (dueFlashcards.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: progressController,
                      builder: (context, _) {
                        return SessionProgress(
                          currentIndex: safeCurrentIndex,
                          totalCards: dueFlashcards.length,
                          combo: progressController.progress.combo,
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: 24),
                  Expanded(
                    child: dueFlashcards.isEmpty
                        ? const EmptyReviewState()
                        : FlashcardView(
                            key: ValueKey(currentFlashcard!.id),
                            question: currentFlashcard.question,
                            answer: currentFlashcard.answer,
                            isAnswerVisible: isAnswerVisible,
                            onTap: toggleAnswer,
                          ),
                  ),
                  if (isAnswerVisible &&
                      dueFlashcards.isNotEmpty &&
                      !_isProcessingReview)
                    AnswerButtons(onSelected: reviewCurrentFlashcard),
                ],
              ),
            ),
            if (currentAchievement != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AchievementBanner(
                  message: currentAchievement!.message,
                  onDismiss: () {
                    setState(() {
                      currentAchievement = null;
                    });
                  },
                ),
              ),
            ..._xpGains.map(
              (gain) => Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: 0,
                right: 0,
                child: Center(
                  child: XpGainLabel(
                    key: gain.key,
                    xp: gain.xp,
                    onFinished: () {
                      if (!mounted) return;
                      setState(() {
                        _xpGains.removeWhere((g) => g.key == gain.key);
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
