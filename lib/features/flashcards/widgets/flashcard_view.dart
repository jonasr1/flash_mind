import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String question;
  final String answer;
  final bool isAnswerVisible;
  final VoidCallback onTap;

  const FlashcardView({
    super.key,
    required this.question,
    required this.answer,
    required this.isAnswerVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isAnswerVisible ? 'Resposta' : 'Pergunta',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  isAnswerVisible ? answer : question,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (!isAnswerVisible) ...[
                  Icon(
                    Icons.visibility_outlined,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clique para ver a resposta',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
