import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/flashcards/screens/create_flashcard_screen.dart';
import 'package:flash_mind/features/flashcards/screens/edit_flashcard_screen.dart';
import '../controllers/deck_details_controller.dart';
import '../models/deck.dart';

class DeckDetailsScreen extends StatefulWidget {
  final Deck deck;

  const DeckDetailsScreen({super.key, required this.deck});

  @override
  State<DeckDetailsScreen> createState() => _DeckDetailsScreenState();
}

class _DeckDetailsScreenState extends State<DeckDetailsScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  Future<void> deleteFlashcard(int index) async {
    final flashcard = widget.deck.flashcards[index];

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apagar carta'),
        content: Text('Deseja apagar a carta "${flashcard.question}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    if (!mounted) return;

    final controller = DeckDetailsController(
      deckService: AppScope.of(context).deckService,
    );

    await controller.deleteFlashcard(deck: widget.deck, flashcard: flashcard);

    if (!mounted) return;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.deck.title);
    descriptionController = TextEditingController(
      text: widget.deck.description,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do baralho')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => CreateFlashcardScreen(deck: widget.deck),
            ),
          );

          if (result == true && mounted) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ex.: Python',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Ex.: Flashcards sobre Python',
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Flashcards', style: textTheme.titleMedium),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.deck.flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = widget.deck.flashcards[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                EditFlashcardScreen(flashcard: flashcard),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    flashcard.question,
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    flashcard.answer,
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => deleteFlashcard(index),
                              icon: const Icon(Icons.delete_outline_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
