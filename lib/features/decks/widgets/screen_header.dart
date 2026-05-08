import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final IconData actionIcon;
  final VoidCallback onActionPressed;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.actionIcon,
    required this.onActionPressed,
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
          child: Text(title, style: Theme.of(context).textTheme.displaySmall),
        ),
        IconButton(onPressed: onActionPressed, icon: Icon(actionIcon)),
      ],
    );
  }
}
