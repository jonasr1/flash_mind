import 'package:flash_mind/features/home/widgets/onboarding_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../models/review_rating.dart';

class AnswerButtons extends StatelessWidget {
  final void Function(ReviewRating rating) onSelected;
  final GlobalKey? showcaseKey;

  const AnswerButtons({super.key, required this.onSelected, this.showcaseKey});

  @override
  Widget build(BuildContext context) {
    final buttonsRow = Row(
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

    if (showcaseKey != null) {
      return Showcase.withWidget(
        scope: 'flashcards',
        key: showcaseKey!,
        targetPadding: EdgeInsets.all(0),
        targetBorderRadius: BorderRadius.circular(16),
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tooltipPosition: TooltipPosition.top,
        container: OnboardingTooltip(
          title: 'Avalie sua resposta',
          description:
              'Escolha a opção que melhor representa o quanto você lembrou da resposta.\n\n'
              'O FlashMind usa essa avaliação para definir quando mostrar este card novamente.\n\n'
              '• Não sabia\n'
              '  Você não conseguiu lembrar da resposta.\n\n'
              '• Difícil\n'
              '  Você lembrou com dificuldade.\n\n'
              '• Fácil\n'
              '  Você lembrou com facilidade.\n\n'
              '💡 Dica: toque novamente no card para voltar à pergunta.',
          currentStep: 1,
          totalSteps: 1,
          onNext: () => ShowcaseView.getNamed('flashcards').dismiss(),
          onSkip: () => ShowcaseView.getNamed('flashcards').dismiss(),
        ),
        child: buttonsRow,
      );
    }

    return buttonsRow;
  }
}

class _AnswerButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<_AnswerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.95), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    _controller.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: ElevatedButton(
        onPressed: _handlePress,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 44),
          backgroundColor: widget.color,
          foregroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(widget.label),
      ),
    );
  }
}
