import 'package:flutter/material.dart';

class AchievementBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const AchievementBanner({
    super.key,
    required this.message,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
