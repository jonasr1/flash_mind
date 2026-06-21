import 'dart:async';
import 'package:flash_mind/features/home/widgets/start_button.dart';
import 'package:flash_mind/features/home/widgets/stats_section.dart';
import 'package:flash_mind/features/home/widgets/stats_help_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flash_mind/features/home/widgets/onboarding_tooltip.dart';

import "package:flash_mind/features/home/data/quotes_data.dart";

import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/home/widgets/header_section.dart';
import 'package:flash_mind/features/home/widgets/level_card.dart';
import 'package:flash_mind/features/home/widgets/quote_card.dart';
import 'package:flash_mind/features/home/models/stats_data.dart';
import 'package:flash_mind/features/progress/screens/streak_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      scope: 'home',
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_home_tour', true);
      },
      onDismiss: (key) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_home_tour', true);
      },
      enableAutoScroll: true,
    );
  }

  @override
  void dispose() {
    ShowcaseView.getNamed('home').unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreenContent();
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  Timer? _refreshTimer;

  final GlobalKey _availableCardsKey = GlobalKey();
  final GlobalKey _startButtonKey = GlobalKey();
  final GlobalKey _levelCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startOnboardingTourIfNeeded();
    });
  }

  Future<void> _startOnboardingTourIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTour = prefs.getBool('has_seen_home_tour') ?? false;
    if (!hasSeenTour) {
      if (mounted) {
        ShowcaseView.getNamed('home').startShowCase([
          _availableCardsKey,
          _startButtonKey,
          _levelCardKey,
        ]);
      }
    }
  }

  Future<void> _dismissTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_home_tour', true);
    if (mounted) {
      ShowcaseView.getNamed('home').dismiss();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final progressController = scope.userProgressController;
    progressController.refreshFor(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: HeaderSection(
                actionIcon: Icons.bar_chart_rounded,
                onActionPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StreakScreen()),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 32, thickness: 1, color: Colors.black26),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 5.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuoteCard(quote: getDailyQuote()),
                        const SizedBox(height: 24),
                        Text(
                          'Seu Progresso',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: progressController,
                          builder: (context, _) {
                            final levelCard = LevelCard(
                              progress: progressController.progress,
                            );

                            return Showcase.withWidget(
                              scope: 'home',
                              key: _levelCardKey,
                              targetBorderRadius: BorderRadius.circular(16),
                              targetShapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              container: OnboardingTooltip(
                                title: 'Seu Progresso',
                                description:
                                    'Ganhe XP enquanto estuda e suba de nível com o tempo.',
                                currentStep: 3,
                                totalSteps: 3,
                                onNext: _dismissTour,
                                onSkip: _dismissTour,
                              ),
                              child: levelCard,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estatísticas',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                              onPressed: () => showStatsHelp(context),
                              icon: Icon(
                                Icons.info_outline_rounded,
                                size: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            progressController,
                            scope.deckService,
                          ]),
                          builder: (context, _) {
                            final stats = StatsData.fromDecks(
                              decks: scope.deckService.decks,
                              streakDays:
                                  progressController.progress.streakDays,
                              reviewsToday:
                                  progressController.progress.reviewsToday,
                              now: DateTime.now(),
                            );

                            return StatsSection(
                              stats: stats,
                              availableCardsKey: _availableCardsKey,
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: StartButton(showcaseKey: _startButtonKey),
            ),
          ],
        ),
      ),
    );
  }
}
