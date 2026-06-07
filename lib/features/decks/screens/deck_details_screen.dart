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
  late Deck _deck;

  bool _hasChanges = false;
  bool _isSaving = false;
  String? _titleError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
    _deck = widget.deck;
    titleController = TextEditingController(text: _deck.title);
    descriptionController = TextEditingController(text: _deck.description);

    titleController.addListener(_checkForChanges);
    descriptionController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final titleChanged = titleController.text.trim() != _deck.title.trim();
    final descriptionChanged =
        descriptionController.text.trim() != _deck.description.trim();

    final hasChanges = titleChanged || descriptionChanged;
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _refreshDeck() async {
    final decks = await AppScope.of(context).deckService.getDecks();
    final updatedDeck = decks.firstWhere((d) => d.id == _deck.id);

    if (!mounted) return;

    setState(() {
      _deck = updatedDeck;
      _hasChanges = false;
      _titleError = null;
      _descriptionError = null;
    });
  }

  Future<void> _saveDeck() async {
    final controller = DeckDetailsController(
      deckService: AppScope.of(context).deckService,
    );

    final title = titleController.text;
    final description = descriptionController.text;

    setState(() {
      _titleError = controller.validateTitle(title);
      _descriptionError = controller.validateDescription(description);
      _isSaving = true;
    });

    if (_titleError != null || _descriptionError != null) {
      setState(() {
        _isSaving = false;
      });
      return;
    }

    try {
      await controller.updateDeck(
        deck: _deck,
        title: title,
        description: description,
      );

      await _refreshDeck();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Baralho editado com sucesso'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        if (e is ArgumentError) {
          _titleError = e.message;
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> deleteFlashcard(int index) async {
    final flashcard = _deck.flashcards[index];
    final context = this.context;

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
    if (!context.mounted) return;

    final controller = DeckDetailsController(
      deckService: AppScope.of(context).deckService,
    );

    await controller.deleteFlashcard(deck: _deck, flashcard: flashcard);

    await _refreshDeck();

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Flashcard apagado com sucesso'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    titleController.removeListener(_checkForChanges);
    descriptionController.removeListener(_checkForChanges);
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar baralho'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : _saveDeck,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => CreateFlashcardScreen(deck: _deck),
            ),
          );
          if (result == true && mounted) {
            await _refreshDeck();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Flashcard criado com sucesso'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova carta'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      hintText: 'Ex.: Python',
                      errorText: _titleError,
                    ),
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Ex.: Flashcards sobre Python',
                      errorText: _descriptionError,
                    ),
                    enabled: !_isSaving,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Flashcards (${_deck.flashcards.length})',
                      style: textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _deck.flashcards.length,
                    itemBuilder: (_, index) {
                      final flashcard = _deck.flashcards[index];

                      return Card(
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context)
                                .push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => EditFlashcardScreen(
                                      deck: _deck,
                                      flashcard: flashcard,
                                    ),
                                  ),
                                );

                            if (result == true && mounted) {
                              await _refreshDeck();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Flashcard editado com sucesso',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
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
        ),
      ),
    );
  }
}
