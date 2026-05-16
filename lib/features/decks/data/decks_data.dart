import 'package:flash_mind/features/flashcards/models/flashcard.dart';

import '../models/deck.dart';

const decks = [
  Deck(
    title: 'Python',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que é uma lista em Python?',
        answer: 'Uma coleção ordenada e mutável.',
      ),
      Flashcard(
        question: 'O que é list comprehension?',
        answer: 'Uma forma concisa de criar listas.',
      ),
    ],
  ),
  Deck(
    title: 'POO',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que é encapsulamento?',
        answer: 'Ocultar detalhes internos.',
      ),
      Flashcard(
        question: 'O que é herança?',
        answer: 'Reutilização entre classes.',
      ),
    ],
  ),
  Deck(
    title: 'Flutter',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que é um Widget?',
        answer: 'Bloco básico da interface.',
      ),
      Flashcard(
        question: 'O que é StatefulWidget?',
        answer: 'Widget que pode mudar de estado.',
      ),
    ],
  ),
  Deck(
    title: 'Django',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que é uma Model?',
        answer: 'Representação de uma tabela.',
      ),
      Flashcard(
        question: 'O que é uma View?',
        answer: 'Lógica que responde requisições.',
      ),
    ],
  ),
  Deck(
    title: 'HTML',
    reviewedCards: 2,
    flashcards: [
      Flashcard(
        question: 'O que é uma tag?',
        answer: 'Elemento estrutural do HTML.',
      ),
      Flashcard(
        question: 'Função do <head>?',
        answer: 'Metadados do documento.',
      ),
    ],
  ),
  Deck(
    title: 'CSS',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que faz margin?',
        answer: 'Espaço externo do elemento.',
      ),
      Flashcard(
        question: 'O que faz padding?',
        answer: 'Espaço interno do elemento.',
      ),
    ],
  ),
  Deck(
    title: 'Git',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que faz git commit?',
        answer: 'Salva mudanças no histórico.',
      ),
      Flashcard(
        question: 'O que é uma branch?',
        answer: 'Linha paralela de desenvolvimento.',
      ),
    ],
  ),
  Deck(
    title: 'SQL',
    reviewedCards: 0,
    flashcards: [
      Flashcard(question: 'O que faz SELECT?', answer: 'Consulta dados.'),
      Flashcard(question: 'O que faz WHERE?', answer: 'Filtra registros.'),
    ],
  ),
  Deck(
    title: 'Linux',
    reviewedCards: 0,
    flashcards: [
      Flashcard(question: 'O que faz ls?', answer: 'Lista arquivos.'),
      Flashcard(question: 'O que faz cd?', answer: 'Muda de diretório.'),
    ],
  ),
  Deck(
    title: 'Dart',
    reviewedCards: 0,
    flashcards: [
      Flashcard(
        question: 'O que é final?',
        answer: 'Variável atribuída uma vez.',
      ),
      Flashcard(
        question: 'O que é const?',
        answer: 'Valor constante em compile-time.',
      ),
    ],
  ),
];
