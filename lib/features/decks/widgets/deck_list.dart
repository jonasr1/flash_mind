import 'package:flutter/material.dart';

import '../models/deck.dart';
import 'deck_list_item.dart';

class DeckList extends StatelessWidget {
  final List<Deck> decks;
  final VoidCallback? onDeckUpdated;

  const DeckList({super.key, required this.decks, this.onDeckUpdated});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: decks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DeckListItem(deck: decks[index], onDeckUpdated: onDeckUpdated),
        );
      },
    );
  }
}
