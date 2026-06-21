import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/decks/screens/create_deck_screen.dart';
import 'package:flash_mind/features/decks/screens/deck_details_screen.dart';
import 'package:flash_mind/features/decks/widgets/create_deck_button.dart';
import 'package:flash_mind/features/decks/widgets/deck_list.dart';
import 'package:flash_mind/features/decks/widgets/decks_summary.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class DecksScreen extends StatefulWidget {
  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  final GlobalKey _firstDeckCardKey = GlobalKey();
  final GlobalKey _createDeckButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      scope: 'decks',
      onFinish: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_decks_tour', true);
      },
      onDismiss: (key) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_decks_tour', true);
      },
      enableAutoScroll: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startOnboardingTourIfNeeded();
    });
  }

  @override
  void dispose() {
    ShowcaseView.getNamed('decks').unregister();
    super.dispose();
  }

  Future<void> _startOnboardingTourIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTour = prefs.getBool('has_seen_decks_tour') ?? false;
    final scope = AppScope.of(context);
    if (!hasSeenTour) {
      if (mounted) {
        if (scope.deckService.decks.isEmpty) {
          ShowcaseView.getNamed('decks').startShowCase([_createDeckButtonKey]);
        } else {
          ShowcaseView.getNamed('decks').startShowCase([
            _createDeckButtonKey,
            _firstDeckCardKey,
          ]);
        }
      }
    }
  }


  Future<void> openCreateDeckScreen() async {
    final createdDeck = await Navigator.of(
      context,
    ).push<Deck>(MaterialPageRoute(builder: (_) => const CreateDeckScreen()));

    if (!mounted) return;

    if (createdDeck != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Baralho criado com sucesso'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DeckDetailsScreen(deck: createdDeck)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scope = AppScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Text(
                    "Baralhos",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 24,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: scope.deckService,
                builder: (context, _) {
                  final decks = scope.deckService.decks;
                  return Scrollbar(
                    thumbVisibility: true,
                    thickness: 5.0,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      children: [
                        DecksSummary(decks: decks),
                        const SizedBox(height: 24),
                        DeckList(
                          decks: decks,
                          firstDeckCardKey: _firstDeckCardKey,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: CreateDeckButton(
                onPressed: openCreateDeckScreen,
                showcaseKey: _createDeckButtonKey,
                totalSteps: scope.deckService.decks.isEmpty ? 1 : 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
