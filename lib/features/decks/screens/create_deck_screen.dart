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

    try {
      await controller.createDeck(
        title: titleController.text,
        description: descriptionController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save deck')));
    }
  }

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Scaffold(
    appBar: AppBar(
      title: const Text('Criar baralho'),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Novo baralho',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 4),
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
                    Text(
                      'Título',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: titleController,
                      enabled: !isSaving,
                      maxLength: 100,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Ex.: Inglês',
                        errorText: titleError,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Descrição',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: descriptionController,
                      enabled: !isSaving,
                      maxLength: 300,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText:
                            'Ex.: Flashcards para praticar vocabulário',
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
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
