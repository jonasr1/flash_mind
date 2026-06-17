import 'dart:async';
import 'package:flash_mind/features/home/widgets/start_button.dart';
import 'package:flash_mind/features/home/widgets/stats_section.dart';
import 'package:flash_mind/features/home/widgets/stats_help_bottom_sheet.dart';
import 'package:flutter/material.dart';

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
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {});
      }
    });
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
                            return LevelCard(
                              progress: progressController.progress,
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

                            return StatsSection(stats: stats);
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: StartButton(),
            ),
          ],
        ),
      ),
    );
  }
}
