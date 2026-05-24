import 'package:flutter/material.dart';

class SessionProgress extends StatelessWidget {
  final int currentIndex;
  final int totalCards;
  final int combo;

  const SessionProgress({
    super.key,
    required this.currentIndex,
    required this.totalCards,
    required this.combo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          '${currentIndex + 1}/$totalCards',
          style: theme.textTheme.bodyMedium,
        ),
        const Spacer(),
        const Icon(
          Icons.local_fire_department_rounded,
          size: 18,
          color: Colors.orange,
        ),
        const SizedBox(width: 4),
        Text(
          'Combo: $combo',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}