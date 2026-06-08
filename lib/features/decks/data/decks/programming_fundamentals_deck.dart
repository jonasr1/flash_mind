import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck programmingFundamentalsDeck = Deck(
  title: 'Fundamentos de Programação',
  flashcards: [
    // =====================
    // CONCEITOS BÁSICOS
    // =====================
    Flashcard(
      question: 'O que é programação?',
      answer:
          'O processo de criar instruções para um computador executar tarefas.',
    ),

    Flashcard(
      question: 'O que é um algoritmo?',
      answer: 'Um conjunto de passos organizados para resolver um problema.',
    ),

    Flashcard(
      question: 'O que é lógica de programação?',
      answer: 'A forma de pensar para resolver problemas usando algoritmos.',
    ),

    Flashcard(
      question: 'O que é um programa?',
      answer: 'Um conjunto de instruções executadas por um computador.',
    ),

    Flashcard(
      question: 'O que é um bug?',
      answer:
          'Um erro no código que faz o programa não funcionar corretamente.',
    ),

    Flashcard(
      question: 'O que é debug?',
      answer: 'Processo de encontrar e corrigir erros no código.',
    ),

    // =====================
    // VARIÁVEIS E DADOS
    // =====================
    Flashcard(
      question: 'O que é uma variável?',
      answer: 'Um espaço na memória usado para armazenar dados.',
    ),

    Flashcard(
      question: 'O que é uma constante?',
      answer:
          'Um valor que não pode ser alterado durante a execução do programa.',
    ),

    Flashcard(
      question: 'Qual a diferença entre variável e constante?',
      answer: 'Variável pode mudar; constante não muda.',
    ),

    Flashcard(
      question: 'O que é um tipo de dado?',
      answer:
          'A classificação do tipo de valor armazenado (ex: int, string, bool).',
    ),

    Flashcard(
      question: 'O que é uma string?',
      answer: 'Um tipo de dado que representa texto.',
    ),

    Flashcard(
      question: 'O que é um inteiro (int)?',
      answer: 'Um número inteiro sem casas decimais.',
    ),

    Flashcard(
      question: 'O que é um booleano (bool)?',
      answer: 'Um tipo de dado com dois valores: verdadeiro ou falso.',
    ),

    // =====================
    // ESTRUTURAS DE CONTROLE
    // =====================
    Flashcard(
      question: 'O que é uma estrutura condicional?',
      answer: 'Um bloco de código que executa decisões com base em condições.',
    ),

    Flashcard(
      question: 'O que é um if?',
      answer: 'Estrutura que executa código se uma condição for verdadeira.',
    ),

    Flashcard(
      question: 'O que é um else?',
      answer: 'Bloco executado quando a condição do if é falsa.',
    ),

    Flashcard(
      question: 'O que é um loop?',
      answer: 'Estrutura que repete um bloco de código.',
    ),

    Flashcard(
      question: 'O que é um for?',
      answer: 'Loop usado quando se sabe o número de repetições.',
    ),

    Flashcard(
      question: 'O que é um while?',
      answer: 'Loop que executa enquanto uma condição for verdadeira.',
    ),

    // =====================
    // FUNÇÕES
    // =====================
    Flashcard(
      question: 'O que é uma função?',
      answer: 'Um bloco de código reutilizável que executa uma tarefa.',
    ),

    Flashcard(
      question: 'Qual a principal vantagem de uma função?',
      answer: 'Reutilização de código.',
    ),

    Flashcard(
      question: 'O que são parâmetros?',
      answer: 'Valores recebidos por uma função.',
    ),

    Flashcard(
      question: 'O que é retorno de função?',
      answer: 'O valor que uma função devolve após ser executada.',
    ),

    // =====================
    // ESTRUTURAS DE DADOS
    // =====================
    Flashcard(
      question: 'O que é uma lista?',
      answer: 'Uma estrutura que armazena múltiplos valores em sequência.',
    ),

    Flashcard(
      question: 'O que é um array?',
      answer: 'Uma estrutura que armazena elementos em posições indexadas.',
    ),

    Flashcard(
      question: 'Qual a diferença entre lista e array?',
      answer: 'Depende da linguagem, mas ambos armazenam múltiplos valores.',
    ),

    // =====================
    // CONCEITOS IMPORTANTES
    // =====================
    Flashcard(
      question: 'O que é entrada (input)?',
      answer: 'Dados fornecidos ao programa.',
    ),

    Flashcard(
      question: 'O que é saída (output)?',
      answer: 'Resultado produzido pelo programa.',
    ),

    Flashcard(
      question: 'O que é compilação?',
      answer: 'Processo de transformar código em linguagem executável.',
    ),

    Flashcard(
      question: 'O que é interpretação?',
      answer: 'Execução do código linha por linha.',
    ),

    Flashcard(
      question: 'Qual a diferença entre compilado e interpretado?',
      answer:
          'Compilado é convertido antes de executar; interpretado executa direto.',
    ),
  ],
);
