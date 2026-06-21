import 'package:flash_mind/features/home/widgets/onboarding_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CreateDeckButton extends StatelessWidget {
  final VoidCallback onPressed;
  final GlobalKey? showcaseKey;
  final int totalSteps;

  const CreateDeckButton({
    super.key,
    required this.onPressed,
    this.showcaseKey,
    this.totalSteps = 1,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('Criar novo baralho'),
        ),
      ),
    );

    if (showcaseKey != null) {
      final isTwoStep = totalSteps == 2;
      button = Showcase.withWidget(
        scope: 'decks',
        key: showcaseKey!,
        targetBorderRadius: BorderRadius.circular(12),
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        container: OnboardingTooltip(
          title: isTwoStep ? 'Criar Baralho' : 'Crie seu primeiro baralho',
          description: isTwoStep
              ? 'Crie seus próprios baralhos para organizar os conteúdos que deseja estudar.'
              : 'Crie um baralho para começar a estudar com flashcards.',
          currentStep: 1,
          totalSteps: totalSteps,
          onNext: isTwoStep
              ? () => ShowcaseView.getNamed('decks').next()
              : () => ShowcaseView.getNamed('decks').dismiss(),
          onSkip: () => ShowcaseView.getNamed('decks').dismiss(),
        ),
        child: button,
      );
    }

    return Padding(padding: const EdgeInsets.only(top: 16), child: button);
  }
}
