import 'package:flutter/material.dart';

class SrsHelpBottomSheet extends StatelessWidget {
  const SrsHelpBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => const SrsHelpBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            Text(
              'Como funciona a repetição espaçada?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Dúvida 1
            Text(
              'Por que os cartões desaparecem depois que respondo?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Os cartões não são removidos do aplicativo. Eles apenas são agendados para aparecer novamente no momento ideal para o seu cérebro revisar. Todo o seu progresso permanece salvo.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Dúvida 2: Entendendo as respostas
            Text(
              'Entendendo as respostas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Não sabia
            _buildExplanationItem(
              context,
              label: 'Não sabia',
              color: colorScheme.error,
              text: 'O cartão retornará rapidamente nesta mesma sessão para ajudar você a fixá-lo.',
            ),
            const SizedBox(height: 12),

            // Difícil
            _buildExplanationItem(
              context,
              label: 'Difícil',
              color: colorScheme.tertiary,
              text: 'O cartão retornará em breve para consolidar a memória.',
            ),
            const SizedBox(height: 12),

            // Fácil
            _buildExplanationItem(
              context,
              label: 'Fácil',
              color: colorScheme.primary,
              text: 'Indica que o conteúdo foi lembrado com facilidade. O aplicativo aumentará gradualmente o intervalo até a próxima revisão.',
            ),
            const SizedBox(height: 32),

            // Botão Entendi
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationItem(
    BuildContext context, {
    required String label,
    required Color color,
    required String text,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
