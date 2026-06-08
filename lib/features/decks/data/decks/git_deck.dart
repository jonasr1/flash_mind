import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck gitDeck = Deck(
  title: 'Git',
  flashcards: [
    Flashcard(
      question: 'Qual comando inicializa um novo repositório Git?',
      answer: 'git init',
    ),

    Flashcard(
      question: 'Qual comando cria uma cópia local de um repositório remoto?',
      answer: 'git clone',
    ),

    Flashcard(
      question: 'Qual comando exibe o estado atual do repositório?',
      answer: 'git status',
    ),

    Flashcard(
      question: 'Qual comando adiciona alterações para a área de staging?',
      answer: 'git add',
    ),

    Flashcard(
      question: 'Qual comando salva alterações no histórico local?',
      answer: 'git commit',
    ),

    Flashcard(
      question: 'Qual comando exibe o histórico de commits?',
      answer: 'git log',
    ),

    Flashcard(
      question: 'Qual comando mostra diferenças entre versões dos arquivos?',
      answer: 'git diff',
    ),

    Flashcard(
      question: 'Qual comando lista, cria ou remove branches?',
      answer: 'git branch',
    ),

    Flashcard(
      question: 'Qual comando troca para outra branch ou commit?',
      answer: 'git checkout',
    ),

    Flashcard(
      question: 'Qual comando moderno é usado para trocar de branch?',
      answer: 'git switch',
    ),

    Flashcard(
      question: 'Qual comando combina alterações de duas branches?',
      answer: 'git merge',
    ),

    Flashcard(
      question:
          'Qual comando baixa e integra alterações do repositório remoto?',
      answer: 'git pull',
    ),

    Flashcard(
      question: 'Qual comando baixa alterações do remoto sem integrá-las?',
      answer: 'git fetch',
    ),

    Flashcard(
      question: 'Qual comando envia commits locais para o repositório remoto?',
      answer: 'git push',
    ),

    Flashcard(
      question: 'Qual comando lista os repositórios remotos configurados?',
      answer: 'git remote -v',
    ),

    Flashcard(
      question:
          'Qual comando armazena temporariamente alterações não commitadas?',
      answer: 'git stash',
    ),

    Flashcard(
      question:
          'Qual comando restaura as alterações armazenadas e remove o stash?',
      answer: 'git stash pop',
    ),

    Flashcard(
      question:
          'Qual comando remove alterações da área de staging ou move o HEAD?',
      answer: 'git reset',
    ),

    Flashcard(
      question: 'Qual comando restaura arquivos para um estado anterior?',
      answer: 'git restore',
    ),

    Flashcard(
      question: 'Qual comando remove arquivos do repositório?',
      answer: 'git rm',
    ),

    Flashcard(
      question: 'Qual comando move ou renomeia arquivos rastreados?',
      answer: 'git mv',
    ),

    Flashcard(
      question: 'Qual comando cria marcadores para commits específicos?',
      answer: 'git tag',
    ),
    Flashcard(
      question:
          'Você terminou uma funcionalidade e deseja registrar as alterações no histórico. Qual comando deve usar?',
      answer: 'git commit',
    ),

    Flashcard(
      question:
          'Você quer enviar seus commits para o GitHub. Qual comando deve usar?',
      answer: 'git push',
    ),

    Flashcard(
      question:
          'Você quer obter as alterações mais recentes do repositório remoto e integrá-las ao seu trabalho. Qual comando deve usar?',
      answer: 'git pull',
    ),

    Flashcard(
      question: 'Você precisa mudar para outra branch. Qual comando pode usar?',
      answer: 'git switch',
    ),

    Flashcard(
      question:
          'Você começou uma tarefa, mas precisa interrompê-la sem fazer commit. Qual comando deve usar?',
      answer: 'git stash',
    ),

    Flashcard(
      question:
          'Você quer combinar as alterações de uma branch em outra. Qual comando deve usar?',
      answer: 'git merge',
    ),

    Flashcard(
      question:
          'Você quer ver quais arquivos foram modificados antes de fazer commit. Qual comando deve usar?',
      answer: 'git status',
    ),
  ],
);
