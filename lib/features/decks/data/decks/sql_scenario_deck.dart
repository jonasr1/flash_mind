import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck sqlDeckScenario = Deck(
  title: 'SQL (Cenários)',
  flashcards: [
    Flashcard(
      question: 'Você quer buscar todos os dados de uma tabela chamada users. Qual comando usar?',
      answer: 'SELECT * FROM users;',
    ),

    Flashcard(
      question: 'Você quer buscar apenas o nome e email dos usuários. Qual comando usar?',
      answer: 'SELECT name, email FROM users;',
    ),

    Flashcard(
      question: 'Você quer filtrar apenas usuários com idade maior que 18. Qual comando usar?',
      answer: 'SELECT * FROM users WHERE age > 18;',
    ),

    Flashcard(
      question: 'Você quer ordenar os usuários por nome em ordem alfabética. Qual comando usar?',
      answer: 'SELECT * FROM users ORDER BY name ASC;',
    ),

    Flashcard(
      question: 'Você quer contar quantos usuários existem na tabela. Qual comando usar?',
      answer: 'SELECT COUNT(*) FROM users;',
    ),

    Flashcard(
      question: 'Você quer somar todos os valores de uma coluna salary. Qual comando usar?',
      answer: 'SELECT SUM(salary) FROM employees;',
    ),

    Flashcard(
      question: 'Você quer calcular a média de idade dos usuários. Qual comando usar?',
      answer: 'SELECT AVG(age) FROM users;',
    ),

    Flashcard(
      question: 'Você quer encontrar o maior salário da tabela. Qual comando usar?',
      answer: 'SELECT MAX(salary) FROM employees;',
    ),

    Flashcard(
      question: 'Você quer encontrar o menor salário da tabela. Qual comando usar?',
      answer: 'SELECT MIN(salary) FROM employees;',
    ),

    Flashcard(
      question: 'Você quer inserir um novo usuário na tabela users. Qual comando usar?',
      answer: "INSERT INTO users (name, email, age) VALUES ('João', 'joao@email.com', 25);",
    ),

    Flashcard(
      question: 'Você quer atualizar o email de um usuário específico. Qual comando usar?',
      answer: "UPDATE users SET email = 'novo@email.com' WHERE id = 1;",
    ),

    Flashcard(
      question: 'Você quer deletar um usuário específico. Qual comando usar?',
      answer: 'DELETE FROM users WHERE id = 1;',
    ),

    Flashcard(
      question: 'Você quer deletar todos os registros de uma tabela sem apagar a estrutura. Qual comando usar?',
      answer: 'TRUNCATE TABLE users;',
    ),

    Flashcard(
      question: 'Você quer apagar completamente uma tabela do banco. Qual comando usar?',
      answer: 'DROP TABLE users;',
    ),

    Flashcard(
      question: 'Você quer evitar registros duplicados em uma consulta. Qual palavra usar?',
      answer: 'DISTINCT',
    ),

    Flashcard(
      question: 'Você quer agrupar dados por uma coluna para fazer agregações. Qual cláusula usar?',
      answer: 'GROUP BY',
    ),

    Flashcard(
      question: 'Você quer filtrar resultados após um GROUP BY. Qual cláusula usar?',
      answer: 'HAVING',
    ),

    Flashcard(
      question: 'Você quer combinar dados de duas tabelas relacionadas. Qual operação usar?',
      answer: 'JOIN',
    ),

    Flashcard(
      question: 'Você quer combinar duas tabelas trazendo apenas registros relacionados. Qual tipo de JOIN usar?',
      answer: 'INNER JOIN',
    ),

    Flashcard(
      question: 'Você quer trazer todos os registros da tabela da esquerda mesmo sem correspondência. Qual JOIN usar?',
      answer: 'LEFT JOIN',
    ),

    Flashcard(
      question: 'Você quer trazer todos os registros das duas tabelas mesmo sem correspondência. Qual JOIN usar?',
      answer: 'FULL OUTER JOIN',
    ),

    Flashcard(
      question: 'Você quer garantir que um campo não aceite valores repetidos. Qual constraint usar?',
      answer: 'UNIQUE',
    ),

    Flashcard(
      question: 'Você quer garantir que uma coluna nunca seja nula. Qual constraint usar?',
      answer: 'NOT NULL',
    ),

    Flashcard(
      question: 'Você quer definir uma chave primária na tabela. Qual constraint usar?',
      answer: 'PRIMARY KEY',
    ),

    Flashcard(
      question: 'Você quer criar uma relação entre duas tabelas. Qual constraint usar?',
      answer: 'FOREIGN KEY',
    ),
  ],
);