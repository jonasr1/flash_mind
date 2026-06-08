// decks_data.dart

import 'package:flash_mind/features/decks/models/deck.dart';

import 'decks/programming_fundamentals_deck.dart';
import 'decks/git_deck.dart';
import 'decks/linux_deck.dart';
import 'decks/linux_scenario_deck.dart';
import 'decks/sql_scenario_deck.dart';
import 'decks/sql_deck.dart';
import 'decks/oop_deck.dart';

final List<Deck> decks = [
  programmingFundamentalsDeck,
  gitDeck,
  oopDeck,
  sqlDeck,
  sqlDeckScenario,
  linuxDeck,
  linuxDeckScenario,
];
