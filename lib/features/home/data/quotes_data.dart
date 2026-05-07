import '../models/quote.dart';

const List<Quote> quotes = [
  Quote(
    text: 'Pequenos passos todos os dias constroem grandes resultados.',
    author: 'FlashMind',
  ),
  Quote(text: 'Consistência supera intensidade.', author: 'Angela Duckworth'),
  Quote(
    text: 'O sucesso é a soma de pequenos esforços repetidos dia após dia.',
    author: 'Robert Collier',
  ),
  Quote(text: 'Aprender nunca esgota a mente.', author: 'Leonardo da Vinci'),
  Quote(
    text:
        'Disciplina é escolher entre o que você quer agora e o que você quer mais.',
    author: 'Abraham Lincoln',
  ),
  Quote(text: 'A prática leva à perfeição.', author: 'Vince Lombardi'),
  Quote(
    text: 'A motivação faz você começar. O hábito faz você continuar.',
    author: 'Jim Ryun',
  ),
  Quote(text: 'Grandes conquistas exigem tempo.', author: 'Maya Angelou'),
];

Quote getDailyQuote() {
  final day = DateTime.now().day;

  return quotes[day % quotes.length];
}
