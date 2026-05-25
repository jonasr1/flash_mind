import 'package:flutter/material.dart';

import '../models/flashcard.dart';

class EditFlashcardScreen extends StatelessWidget {
  final Flashcard flashcard;

  const EditFlashcardScreen({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit flashcard')),
      
      body: const SafeArea(child: SizedBox.shrink()),
    );
  }
}
