import 'package:flash_mind/features/decks/screens/decks_screen.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'onboarding_tooltip.dart';

class StartButton extends StatelessWidget {
  final GlobalKey? showcaseKey;

  const StartButton({super.key, this.showcaseKey});

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const DecksScreen()));
      },
      icon: const Icon(Icons.play_arrow_rounded, size: 24),
      label: const Text('Ver Meus Baralhos'),
    );

    if (showcaseKey != null) {
      return Showcase.withWidget(
        scope: 'home',
        key: showcaseKey!,
        targetBorderRadius: BorderRadius.circular(12),
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        container: OnboardingTooltip(
          title: 'Começar a Estudar',
          description:
              'É por aqui que você inicia suas revisões diárias de flashcards.',
          currentStep: 2,
          totalSteps: 3,
          onNext: () => ShowcaseView.getNamed('home').next(),
          onSkip: () => ShowcaseView.getNamed('home').dismiss(),
        ),
        child: button,
      );
    }

    return button;
  }
}
