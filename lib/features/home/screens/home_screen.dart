import 'package:flash_mind/features/home/data/stats_data.dart';
import 'package:flash_mind/features/home/widgets/start_button.dart';
import 'package:flash_mind/features/home/widgets/stats_section.dart';
import 'package:flutter/material.dart';

import 'package:flash_mind/features/home/data/user_progress_data.dart';
import "package:flash_mind/features/home/data/quotes_data.dart";

import 'package:flash_mind/features/home/widgets/header_section.dart';
import 'package:flash_mind/features/home/widgets/level_card.dart';
import 'package:flash_mind/features/home/widgets/quote_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
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
                      LevelCard(progress: userProgress),
                      const SizedBox(height: 24),
                      Text(
                        'Estatísticas',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      StatsSection(stats: statsData),
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
