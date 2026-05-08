import 'package:flash_mind/features/decks/data/decks_data.dart';
import 'package:flash_mind/features/decks/widgets/create_deck_button.dart';
import 'package:flash_mind/features/decks/widgets/deck_list.dart';
import 'package:flash_mind/features/decks/widgets/decks_summary.dart';
import 'package:flash_mind/features/decks/widgets/screen_header.dart';
import 'package:flutter/material.dart';

class DecksScreen extends StatelessWidget {
  const DecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              ScreenHeader(
                title: 'Baralhos',
                actionIcon: Icons.bar_chart_rounded,
                onActionPressed: () {},
              ),

              Divider(
                height: 24,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),

              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      const DecksSummary(),
                      const SizedBox(height: 24),
                      DeckList(decks: decks),
                    ],
                  ),
                ),
              ),
              const CreateDeckButton(),
            ],
          ),
        ),
      ),
    );
  }
}
