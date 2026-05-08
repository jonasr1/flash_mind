import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.play_arrow_rounded, size: 24),
      label: const Text('Iniciar Sessão'),
    );
  }
}
