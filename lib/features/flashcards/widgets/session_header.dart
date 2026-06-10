import 'package:flutter/material.dart';

class SessionHeader extends StatelessWidget {
  final String deckTitle;

  const SessionHeader({
    super.key,
    required this.deckTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        Expanded(
          child: Text(
            'Baralho: $deckTitle',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          width: 48,
        ),
      ],
    );
  }
}