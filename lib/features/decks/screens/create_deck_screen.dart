import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import '../controllers/create_deck_controller.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? titleError;
  String? descriptionError;
  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveDeck() async {
    final controller = CreateDeckController(
      deckService: AppScope.of(context).deckService,
    );

    final nextTitleError = controller.validateTitle(titleController.text);
    final nextDescriptionError = controller.validateDescription(
      descriptionController.text,
    );

    setState(() {
      titleError = nextTitleError;
      descriptionError = nextDescriptionError;
    });

    if (nextTitleError != null || nextDescriptionError != null) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final uniqueError = await controller.validateTitleUnique(
      titleController.text,
    );
    if (uniqueError != null) {
      setState(() {
        titleError = uniqueError;
        isSaving = false;
      });
      return;
    }

    try {
      final createdDeck = await controller.createDeck(
        title: titleController.text,
        description: descriptionController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(createdDeck);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      final message = e is ArgumentError ? e.message : 'Failed to save deck';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar baralho')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Organize seus flashcards por assunto ou tema.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: titleController,
                        enabled: !isSaving,
                        maxLength: 100,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          hintText: 'Ex.: Inglês',
                          errorText: titleError,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        enabled: !isSaving,
                        maxLength: 300,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          hintText: 'Ex.: Flashcards para praticar vocabulário',
                          errorText: descriptionError,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveDeck,
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
