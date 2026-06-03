import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/screens/create_deck_screen.dart';
import 'package:flash_mind/features/decks/screens/deck_details_screen.dart';
import 'package:flash_mind/features/decks/widgets/create_deck_button.dart';
import 'package:flash_mind/features/decks/widgets/deck_list.dart';
import 'package:flash_mind/features/decks/widgets/decks_summary.dart';
import 'package:flash_mind/features/decks/widgets/screen_header.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DecksScreen extends StatefulWidget {
  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  List<Deck> decks = [];

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadDecks();
  }

  Future<void> loadDecks() async {
    final loadedDecks = await AppScope.of(context).deckService.getDecks();

    if (!mounted) return;

    setState(() {
      decks = loadedDecks;
    });
  }

  Future<void> openCreateDeckScreen() async {
    final createdDeck = await Navigator.of(
      context,
    ).push<Deck>(MaterialPageRoute(builder: (_) => const CreateDeckScreen()));

    if (!mounted) return;

    if (createdDeck != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DeckDetailsScreen(deck: createdDeck)),
      );

      if (!mounted) return;
    }

    await loadDecks();
  }

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
                onActionPressed: () {
                  // TODO: Implement action
                },
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
                      DecksSummary(decks: decks),
                      const SizedBox(height: 24),
                      DeckList(decks: decks, onDeckUpdated: loadDecks),
                    ],
                  ),
                ),
              ),
              CreateDeckButton(onPressed: openCreateDeckScreen),
            ],
          ),
        ),
      ),
    );
  }
}
