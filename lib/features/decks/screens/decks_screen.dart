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

  late final TextEditingController _searchController;
  String _searchQuery = '';
  bool _filterOnlyPending = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    ShowcaseView.getNamed('decks').unregister();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scope = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Baralhos",
          style: theme.textTheme.displaySmall,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 24,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar baralho...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: !_filterOnlyPending,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filterOnlyPending = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Pendentes'),
                        selected: _filterOnlyPending,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _filterOnlyPending = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedBuilder(
                animation: scope.deckService,
                builder: (context, _) {
                  final decks = scope.deckService.decks;
                  final filteredDecks = decks.where((deck) {
                    final matchesSearch = deck.title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                    final matchesFilter = !_filterOnlyPending || (deck.progress < 1.0);
                    return matchesSearch && matchesFilter;
                  }).toList();

                  return Scrollbar(
                    thumbVisibility: true,
                    thickness: 5.0,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      children: [
                        DecksSummary(decks: decks),
                        const SizedBox(height: 24),
                        if (filteredDecks.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 64,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum baralho localizado',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tente ajustar seus termos de pesquisa ou filtros.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          DeckList(
                            decks: filteredDecks,
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
