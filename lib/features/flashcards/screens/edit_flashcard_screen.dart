import 'package:flutter/material.dart';

import 'package:flash_mind/core/app_scope.dart';
import 'package:flash_mind/features/decks/models/deck.dart';
import '../controllers/edit_flashcard_controller.dart';
import '../models/flashcard.dart';

class EditFlashcardScreen extends StatefulWidget {
  final Deck deck;
  final Flashcard flashcard;

  const EditFlashcardScreen({
    super.key,
    required this.deck,
    required this.flashcard,
  });

  @override
  State<EditFlashcardScreen> createState() => _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  late final TextEditingController questionController;
  late final TextEditingController answerController;

  String? questionError;
  String? answerError;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.flashcard.question);
    answerController = TextEditingController(text: widget.flashcard.answer);
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  Future<void> saveFlashcard() async {
    final controller = EditFlashcardController(
      deckService: AppScope.of(context).deckService,
    );

    final nextQuestionError = controller.validateQuestion(
      questionController.text,
    );
    final nextAnswerError = controller.validateAnswer(answerController.text);

    String? nextDuplicateError;
    if (nextQuestionError == null && nextAnswerError == null) {
      nextDuplicateError = controller.validateDuplicate(
        deck: widget.deck,
        question: questionController.text,
        answer: answerController.text,
        excludeId: widget.flashcard.id,
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
      await controller.updateFlashcard(
        deck: widget.deck,
        flashcard: widget.flashcard,
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao salvar flashcard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar flashcard')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edite as informações do cartão no baralho ${widget.deck.title}',
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
                      onPressed: isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
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
