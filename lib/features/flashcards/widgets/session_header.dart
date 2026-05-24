import 'package:flutter/material.dart';

class SessionHeader extends StatelessWidget {
  final String deckTitle;
  const SessionHeader({super.key, required this.deckTitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        Text(
          'Baralho: $deckTitle',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
