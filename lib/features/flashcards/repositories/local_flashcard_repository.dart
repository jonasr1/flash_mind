import '../models/flashcard.dart';
import 'flashcard_repository.dart';

class LocalFlashcardRepository implements FlashcardRepository {
  @override
  Future<List<Flashcard>> getFlashcards() async {
    return [
      Flashcard(
        question: 'O que é Dart?',
        answer: 'Uma linguagem de programação usada com Flutter',
      ),
      Flashcard(
        question: 'O que é Flutter?',
        answer: 'Framework para construir apps multiplataforma',
      ),
    ];
  }
}
