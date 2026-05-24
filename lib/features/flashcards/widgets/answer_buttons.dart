import 'package:flutter/material.dart';

import '../models/review_rating.dart';

class AnswerButtons extends StatelessWidget {
  final void Function(ReviewRating rating) onSelected;

  const AnswerButtons({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _AnswerButton(
            label: 'Não sabia',
            color: Colors.red,
            onPressed: () => onSelected(ReviewRating.forgot),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: _AnswerButton(
            label: 'Difícil',
            color: Colors.orange,
            onPressed: () => onSelected(ReviewRating.difficult),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: _AnswerButton(
            label: 'Fácil',
            color: Colors.green,
            onPressed: () => onSelected(ReviewRating.easy),
          ),
        ),
      ],
    );
  }
}
class _AnswerButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 44),
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(label),
    );
  }
}