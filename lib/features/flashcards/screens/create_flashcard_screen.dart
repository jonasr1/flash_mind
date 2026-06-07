import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import '../controllers/create_flashcard_controller.dart';

class CreateFlashcardScreen extends StatefulWidget {
  final Deck deck;

  const CreateFlashcardScreen({super.key, required this.deck});

  @override
  State<CreateFlashcardScreen> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  final questionController = TextEditingController();
  final answerController = TextEditingController();

  String? questionError;
  String? answerError;
  bool isSaving = false;

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Future<void> saveFlashcard() async {
    final controller = CreateFlashcardController(
      deckService: AppScope.of(context).deckService,
    );

    final nextQuestionError =
        controller.validateQuestion(questionController.text);
    final nextAnswerError = controller.validateAnswer(answerController.text);

    String? nextDuplicateError;
    if (nextQuestionError == null && nextAnswerError == null) {
      nextDuplicateError = controller.validateDuplicate(
        deck: widget.deck,
        question: questionController.text,
        answer: answerController.text,
      );
    }

    setState(() {
      questionError = nextQuestionError ?? nextDuplicateError;
      answerError = nextAnswerError;
    });

    if (nextQuestionError != null ||
        nextAnswerError != null ||
        nextDuplicateError != null) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await controller.createFlashcard(
        deck: widget.deck,
        question: questionController.text,
        answer: answerController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar flashcard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Criar flashcard')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adicione um novo cartão ao baralho ${widget.deck.title}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: questionController,
                        enabled: !isSaving,
                        decoration: InputDecoration(
                          labelText: 'Pergunta',
                          hintText: 'Digite a pergunta',
                          errorText: questionError,
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: answerController,
                        enabled: !isSaving,
                        decoration: InputDecoration(
                          labelText: 'Resposta',
                          hintText: 'Digite a resposta',
                          errorText: answerError,
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
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
                      onPressed: isSaving ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveFlashcard,
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
