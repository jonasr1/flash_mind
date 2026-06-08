import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck linuxDeckScenario = Deck(
  title: 'Linux (Cenários)',
  flashcards: [
    Flashcard(
      question:
          'Você está dentro de uma pasta e quer ver quais arquivos existem nela. O que você usa?',
      answer: 'ls',
    ),

    Flashcard(
      question:
          'Você precisa saber em qual diretório está no terminal. Qual comando usar?',
      answer: 'pwd',
    ),

    Flashcard(
      question:
          'Você quer entrar em uma pasta chamada "projetos". O que você usa?',
      answer: 'cd projetos',
    ),

    Flashcard(
      question: 'Você precisa voltar para a pasta anterior. Qual comando usar?',
      answer: 'cd ..',
    ),

    Flashcard(
      question:
          'Você quer criar uma nova pasta chamada "app". Qual comando usar?',
      answer: 'mkdir app',
    ),

    Flashcard(
      question:
          'Você quer criar um arquivo vazio chamado "main.py". Qual comando usar?',
      answer: 'touch main.py',
    ),

    Flashcard(
      question:
          'Você precisa apagar um arquivo chamado "teste.txt". Qual comando usar?',
      answer: 'rm teste.txt',
    ),

    Flashcard(
      question:
          'Você quer copiar um arquivo "a.txt" para "b.txt". Qual comando usar?',
      answer: 'cp a.txt b.txt',
    ),

    Flashcard(
      question:
          'Você quer renomear o arquivo "old.txt" para "new.txt". Qual comando usar?',
      answer: 'mv old.txt new.txt',
    ),

    Flashcard(
      question:
          'Você quer ver o conteúdo de um arquivo rapidamente no terminal. Qual comando usar?',
      answer: 'cat arquivo.txt',
    ),

    Flashcard(
      question:
          'Um arquivo é muito grande e você quer visualizar por partes. Qual comando usar?',
      answer: 'less arquivo.txt',
    ),

    Flashcard(
      question:
          'Você quer ver apenas as primeiras linhas de um arquivo. Qual comando usar?',
      answer: 'head arquivo.txt',
    ),

    Flashcard(
      question:
          'Você quer ver apenas as últimas linhas de um arquivo. Qual comando usar?',
      answer: 'tail arquivo.txt',
    ),

    Flashcard(
      question:
          'Você quer procurar a palavra "erro" dentro de arquivos. Qual comando usar?',
      answer: 'grep erro arquivo.txt',
    ),

    Flashcard(
      question:
          'Você quer encontrar um arquivo chamado "config.json" no sistema. Qual comando usar?',
      answer: 'find / -name config.json',
    ),

    Flashcard(
      question:
          'Você quer ver todos os processos rodando no sistema. Qual comando usar?',
      answer: 'ps',
    ),

    Flashcard(
      question:
          'Você quer ver processos em tempo real e consumo de CPU. Qual comando usar?',
      answer: 'top',
    ),

    Flashcard(
      question:
          'Um programa travou e você quer encerrá-lo pelo PID. Qual comando usar?',
      answer: 'kill PID',
    ),

    Flashcard(
      question:
          'Você quer juntar a saída de um comando com outro comando. Qual operador usar?',
      answer: '| (pipe)',
    ),

    Flashcard(
      question:
          'Você quer salvar a saída de um comando em um arquivo (substituindo o conteúdo). Qual operador usar?',
      answer: '>',
    ),

    Flashcard(
      question:
          'Você quer adicionar a saída de um comando no final de um arquivo. Qual operador usar?',
      answer: '>>',
    ),

    Flashcard(
      question:
          'Você quer alterar permissões de um arquivo para leitura e execução. Qual comando usar?',
      answer: 'chmod',
    ),

    Flashcard(
      question: 'Você quer mudar o dono de um arquivo. Qual comando usar?',
      answer: 'chown',
    ),
  ],
);
