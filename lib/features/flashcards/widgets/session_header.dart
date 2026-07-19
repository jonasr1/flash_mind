import 'package:flutter/material.dart';

class SessionHeader extends StatelessWidget {
  final String deckTitle;
  final VoidCallback? onHelpPressed;

  const SessionHeader({
    super.key,
    required this.deckTitle,
    this.onHelpPressed,
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
        if (onHelpPressed != null)
          IconButton(
            onPressed: onHelpPressed,
            icon: const Icon(Icons.help_outline),
          )
        else
          const SizedBox(
            width: 48,
          ),
      ],
    );
  }
}