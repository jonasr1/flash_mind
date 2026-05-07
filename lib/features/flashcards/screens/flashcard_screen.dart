import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../repositories/local_flashcard_repository.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final repository = LocalFlashcardRepository();

  List<Flashcard> flashcards = [];
  int currentIndex = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void loadFlashcards() async {
    final data = await repository.getFlashcards();
    setState(() {
      flashcards = data;
    });
  }

  void nextCard() {
    setState(() {
      currentIndex++;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final card = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(card.question, style: const TextStyle(fontSize: 20)),

            const SizedBox(height: 20),

            if (showAnswer)
              Text(card.answer, style: const TextStyle(fontSize: 18)),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  showAnswer = true;
                });
              },
              child: const Text('Mostrar resposta'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(onPressed: nextCard, child: const Text('Próximo')),
          ],
        ),
      ),
    );
  }
}
