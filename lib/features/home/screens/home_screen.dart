import 'package:flash_mind/features/home/widgets/start_button.dart';
import 'package:flash_mind/features/home/widgets/stats_section.dart';
import 'package:flutter/material.dart';

import "package:flash_mind/features/home/data/quotes_data.dart";

import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
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
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final progressController = scope.userProgressController;
    progressController.refreshFor(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(
                actionIcon: Icons.bar_chart_rounded,
                onActionPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StreakScreen()),
                  );
                },
              ),
              const Divider(height: 32, thickness: 1, color: Colors.black26),
              Expanded(
                child: SingleChildScrollView(
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
                      Text(
                        'Estatísticas',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: progressController,
                        builder: (context, _) {
                          return FutureBuilder<List<Deck>>(
                            future: scope.deckService.getDecks(),
                            builder: (context, snapshot) {
                              final stats = StatsData.fromDecks(
                                decks: snapshot.data ?? [],
                                streakDays:
                                    progressController.progress.streakDays,
                                now: DateTime.now(),
                              );

                              return StatsSection(stats: stats);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              const StartButton(),
            ],
          ),
        ),
      ),
    );
  }
}
