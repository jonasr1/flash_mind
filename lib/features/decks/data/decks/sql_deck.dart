import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck sqlDeck = Deck(
  title: 'SQL',
  flashcards: [
    // =====================
    // CONCEITOS BÁSICOS
    // =====================

    Flashcard(
      question: 'O que é SQL?',
      answer: 'Uma linguagem usada para manipular e consultar bancos de dados relacionais.',
    ),

    Flashcard(
      question: 'O que é um banco de dados relacional?',
      answer: 'Um banco que organiza dados em tabelas relacionadas entre si.',
    ),

    Flashcard(
      question: 'O que é uma tabela?',
      answer: 'Estrutura que armazena dados em linhas e colunas.',
    ),

    Flashcard(
      question: 'O que é uma linha (row)?',
      answer: 'Um registro individual dentro de uma tabela.',
    ),

    Flashcard(
      question: 'O que é uma coluna?',
      answer: 'Um campo que representa um tipo de dado na tabela.',
    ),

    // =====================
    // SELECT BÁSICO
    // =====================

    Flashcard(
      question: 'O que faz o comando SELECT?',
      answer: 'Consulta dados de uma tabela.',
    ),

    Flashcard(
      question: 'O que faz SELECT * FROM tabela?',
      answer: 'Retorna todos os dados da tabela.',
    ),

    Flashcard(
      question: 'Qual comando é usado para buscar dados no SQL?',
      answer: 'SELECT',
    ),

    Flashcard(
      question: 'O que faz a cláusula WHERE?',
      answer: 'Filtra registros com base em uma condição.',
    ),

    Flashcard(
      question: 'Qual a função do ORDER BY?',
      answer: 'Ordenar os resultados.',
    ),

    Flashcard(
      question: 'O que faz o DISTINCT?',
      answer: 'Remove valores duplicados dos resultados.',
    ),

    // =====================
    // AGREGAÇÃO
    // =====================

    Flashcard(
      question: 'O que faz COUNT()?',
      answer: 'Conta o número de registros.',
    ),

    Flashcard(
      question: 'O que faz SUM()?',
      answer: 'Soma valores de uma coluna.',
    ),

    Flashcard(
      question: 'O que faz AVG()?',
      answer: 'Calcula a média dos valores.',
    ),

    Flashcard(
      question: 'O que faz MAX()?',
      answer: 'Retorna o maior valor.',
    ),

    Flashcard(
      question: 'O que faz MIN()?',
      answer: 'Retorna o menor valor.',
    ),

    // =====================
    // MANIPULAÇÃO DE DADOS
    // =====================

    Flashcard(
      question: 'O que faz INSERT INTO?',
      answer: 'Insere novos registros em uma tabela.',
    ),

    Flashcard(
      question: 'O que faz UPDATE?',
      answer: 'Atualiza registros existentes.',
    ),

    Flashcard(
      question: 'O que faz DELETE?',
      answer: 'Remove registros de uma tabela.',
    ),

    // =====================
    // ESTRUTURA DE TABELA
    // =====================

    Flashcard(
      question: 'O que faz CREATE TABLE?',
      answer: 'Cria uma nova tabela no banco de dados.',
    ),

    Flashcard(
      question: 'O que faz DROP TABLE?',
      answer: 'Remove uma tabela do banco de dados.',
    ),

    Flashcard(
      question: 'O que faz ALTER TABLE?',
      answer: 'Modifica uma tabela existente.',
    ),

    // =====================
    // RELACIONAMENTOS
    // =====================

    Flashcard(
      question: 'O que é PRIMARY KEY?',
      answer: 'Identificador único de uma tabela.',
    ),

    Flashcard(
      question: 'O que é FOREIGN KEY?',
      answer: 'Chave que cria relacionamento entre tabelas.',
    ),

    Flashcard(
      question: 'O que é um JOIN?',
      answer: 'Combina dados de duas ou mais tabelas.',
    ),
  ],
);