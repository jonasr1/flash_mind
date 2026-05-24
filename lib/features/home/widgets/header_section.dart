import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final IconData actionIcon;
  final VoidCallback onActionPressed;

  const HeaderSection({
    super.key,
    required this.actionIcon,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.psychology_outlined,
                size: 32,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FlashMind',
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 20),
                ),
                Text('Treine sua mente', style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
        IconButton(onPressed: onActionPressed, icon: Icon(actionIcon)),
      ],
    );
  }
}
