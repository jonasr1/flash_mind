import 'dart:async';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';
import 'package:flash_mind/features/flashcards/models/flashcard_achievement.dart';
import 'package:flash_mind/features/flashcards/models/review_rating.dart';
import 'package:flash_mind/features/flashcards/utils/review_utils.dart';
import 'package:flash_mind/features/flashcards/widgets/achievement_banner.dart';
import 'package:flash_mind/features/flashcards/widgets/answer_buttons.dart';
import 'package:flash_mind/features/flashcards/widgets/empty_review_state.dart';
import 'package:flash_mind/features/flashcards/widgets/session_progress.dart';
import 'package:flash_mind/features/flashcards/widgets/xp_gain_label.dart';
import 'package:flash_mind/features/home/widgets/onboarding_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

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
  final GlobalKey _flashcardKey = GlobalKey();
  final GlobalKey _ratingKey = GlobalKey();
  bool isAnswerVisible = false;

  List<Flashcard> _sessionQueue = [];
  int _initialQueueLength = 0;
  int _completedCardsCount = 0;
  final Map<String, int> _cardExposureCount = {};
  final Set<String> _forgotXpAwardedCards = {};

  FlashcardAchievement? currentAchievement;
  final List<XpGainData> _xpGains = [];

  bool _isProcessingReview = false;

  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      scope: 'flashcards',
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        if (isAnswerVisible) {
          await prefs.setBool('has_seen_rating_tour', true);
        } else {
          await prefs.setBool('has_seen_study_tour', true);
        }
      },
      onDismiss: (key) async {
        final prefs = await SharedPreferences.getInstance();
        if (key == _flashcardKey) {
          await prefs.setBool('has_seen_study_tour', true);
        } else if (key == _ratingKey) {
          await prefs.setBool('has_seen_rating_tour', true);
        } else {
          if (isAnswerVisible) {
            await prefs.setBool('has_seen_rating_tour', true);
          } else {
            await prefs.setBool('has_seen_study_tour', true);
          }
        }
      },
      enableAutoScroll: true,
    );

    _sessionQueue = _getDueFlashcards(DateTime.now());
    _initialQueueLength = _sessionQueue.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStudyTourIfNeeded();
    });
  }

  @override
  void dispose() {
    ShowcaseView.getNamed('flashcards').unregister();
    super.dispose();
  }

  Future<void> _startStudyTourIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTour = prefs.getBool('has_seen_study_tour') ?? false;
    if (!hasSeenTour && _sessionQueue.isNotEmpty) {
      if (mounted) {
        ShowcaseView.getNamed('flashcards').startShowCase([_flashcardKey]);
      }
    }
  }

  Future<void> _startRatingTourIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTour = prefs.getBool('has_seen_rating_tour') ?? false;
    if (!hasSeenTour && isAnswerVisible && _sessionQueue.isNotEmpty) {
      if (mounted) {
        ShowcaseView.getNamed('flashcards').startShowCase([_ratingKey]);
      }
    }
  }

  List<Flashcard> _getDueFlashcards(DateTime now) {
    return widget.deck.flashcards
        .where((card) => card.nextReviewAt.isBefore(now))
        .toList();
  }

  void _showAchievement(FlashcardAchievement achievement) {
    setState(() {
      currentAchievement = achievement;
    });
  }

  Future<void> reviewCurrentFlashcard(ReviewRating rating) async {
    if (_isProcessingReview) return;
    if (_sessionQueue.isEmpty) return;

    final currentCard = _sessionQueue.first;
    var shouldShowSessionCompletedDialog = false;

    final progressController = AppScope.of(context).userProgressController;
    final oldProgress = progressController.progress;

    // Calculate actual XP to award (and animation) (FR-01, FR-02, FR-03, FR-05)
    int xpGained = 0;
    if (rating == ReviewRating.forgot) {
      if (!_forgotXpAwardedCards.contains(currentCard.id)) {
        xpGained = 5;
      } else {
        xpGained = 0;
      }
    } else if (rating == ReviewRating.difficult) {
      xpGained = 10;
    } else if (rating == ReviewRating.easy) {
      xpGained = 15;
    }

    setState(() {
      _isProcessingReview = true;
      isAnswerVisible = false;
    });

    try {
      await AppScope.of(context).reviewService.reviewFlashcard(
        widget.deck,
        currentCard,
        rating,
        customXp: xpGained,
      );

      if (!mounted) return;

      setState(() {
        if (xpGained > 0) {
          _xpGains.add(XpGainData(UniqueKey(), xpGained));
        }
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
        final exposures = (_cardExposureCount[currentCard.id] ?? 0) + 1;
        _cardExposureCount[currentCard.id] = exposures;

        _sessionQueue.removeAt(0);

        if (rating == ReviewRating.forgot) {
          if (exposures < 3) {
            final insertIndex = _sessionQueue.length >= 2
                ? 2
                : _sessionQueue.length;
            _sessionQueue.insert(insertIndex, currentCard);
          }
          _forgotXpAwardedCards.add(currentCard.id);
        } else {
          _completedCardsCount++;
        }

        shouldShowSessionCompletedDialog = _sessionQueue.isEmpty;
      });

      if (shouldShowSessionCompletedDialog) {
        showSessionCompletedDialog();
      }
    } catch (error, stackTrace) {
      debugPrint('Error saving review: $error\n$stackTrace');
      if (mounted) {
        setState(() {
          isAnswerVisible = true;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save review. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
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
            'Os próximos cartões serão disponibilizados automaticamente no momento adequado para reforçar sua aprendizagem.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // dialog

                if (mounted) {
                  Navigator.of(this.context).pop();
                }
              },
              child: const Text('Voltar aos baralhos'),
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

    if (isAnswerVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startRatingTourIfNeeded();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFlashcard = _sessionQueue.isEmpty ? null : _sessionQueue.first;
    final progressController = AppScope.of(context).userProgressController;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Baralho: ${widget.deck.title}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_sessionQueue.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: progressController,
                      builder: (context, _) {
                        return SessionProgress(
                          currentIndex: _completedCardsCount,
                          combo: progressController.progress.combo,
                          totalCards: _initialQueueLength,
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(context).colorScheme.outlineVariant),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _sessionQueue.isEmpty
                        ? const EmptyReviewState()
                        : Showcase.withWidget(
                            scope: 'flashcards',
                            key: _flashcardKey,
                            targetBorderRadius: BorderRadius.circular(16),
                            targetShapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            container: OnboardingTooltip(
                              title: 'Revelar a Resposta',
                              description: 'Toque no card para ver a resposta.',
                              currentStep: 1,
                              totalSteps: 1,
                              onNext: () =>
                                  ShowcaseView.getNamed('flashcards').dismiss(),
                              onSkip: () =>
                                  ShowcaseView.getNamed('flashcards').dismiss(),
                            ),
                            child: FlashcardView(
                              key: ValueKey(currentFlashcard!.id),
                              question: currentFlashcard.question,
                              answer: currentFlashcard.answer,
                              isAnswerVisible: isAnswerVisible,
                              onTap: toggleAnswer,
                            ),
                          ),
                  ),
                  if (isAnswerVisible &&
                      _sessionQueue.isNotEmpty &&
                      !_isProcessingReview)
                    AnswerButtons(
                      onSelected: reviewCurrentFlashcard,
                      showcaseKey: _ratingKey,
                    ),
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
