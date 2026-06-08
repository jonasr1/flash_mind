import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck linuxDeck = Deck(
  title: 'Linux',
  flashcards: [
    // =====================
    // COMANDOS BÁSICOS
    // =====================
    Flashcard(
      question: 'O que faz o comando ls?',
      answer: 'Lista arquivos e diretórios.',
    ),
    Flashcard(
      question: 'Qual comando lista arquivos e diretórios?',
      answer: 'ls',
    ),

    Flashcard(
      question: 'O que faz o comando pwd?',
      answer: 'Mostra o diretório atual.',
    ),
    Flashcard(
      question: 'Qual comando mostra o diretório atual?',
      answer: 'pwd',
    ),

    Flashcard(
      question: 'O que faz o comando cd?',
      answer: 'Muda de diretório.',
    ),
    Flashcard(question: 'Qual comando muda de diretório?', answer: 'cd'),

    Flashcard(
      question: 'O que faz o comando mkdir?',
      answer: 'Cria diretórios.',
    ),
    Flashcard(question: 'Qual comando cria diretórios?', answer: 'mkdir'),

    Flashcard(
      question: 'O que faz o comando touch?',
      answer: 'Cria arquivos vazios ou atualiza data de modificação.',
    ),
    Flashcard(question: 'Qual comando cria arquivos vazios?', answer: 'touch'),

    Flashcard(
      question: 'O que faz o comando rm?',
      answer: 'Remove arquivos ou diretórios.',
    ),
    Flashcard(
      question: 'Qual comando remove arquivos ou diretórios?',
      answer: 'rm',
    ),

    Flashcard(
      question: 'O que faz o comando cp?',
      answer: 'Copia arquivos ou diretórios.',
    ),
    Flashcard(question: 'Qual comando copia arquivos?', answer: 'cp'),

    Flashcard(
      question: 'O que faz o comando mv?',
      answer: 'Move ou renomeia arquivos.',
    ),
    Flashcard(
      question: 'Qual comando move ou renomeia arquivos?',
      answer: 'mv',
    ),

    // =====================
    // VISUALIZAÇÃO
    // =====================
    Flashcard(
      question: 'O que faz o comando cat?',
      answer: 'Exibe o conteúdo de arquivos.',
    ),
    Flashcard(
      question: 'Qual comando exibe conteúdo de arquivos?',
      answer: 'cat',
    ),

    Flashcard(
      question: 'O que faz o comando less?',
      answer: 'Exibe arquivos com paginação.',
    ),
    Flashcard(
      question: 'Qual comando permite visualizar arquivos paginados?',
      answer: 'less',
    ),

    Flashcard(
      question: 'O que faz o comando head?',
      answer: 'Mostra as primeiras linhas de um arquivo.',
    ),
    Flashcard(
      question: 'O que faz o comando tail?',
      answer: 'Mostra as últimas linhas de um arquivo.',
    ),

    // =====================
    // PERMISSÕES
    // =====================
    Flashcard(
      question: 'O que faz o comando chmod?',
      answer: 'Altera permissões de arquivos.',
    ),
    Flashcard(
      question: 'Qual comando altera permissões de arquivos?',
      answer: 'chmod',
    ),

    Flashcard(
      question: 'O que faz o comando chown?',
      answer: 'Altera o proprietário de arquivos.',
    ),
    Flashcard(
      question: 'Qual comando altera o dono de um arquivo?',
      answer: 'chown',
    ),

    // =====================
    // BUSCA E FILTRO
    // =====================
    Flashcard(
      question: 'O que faz o comando grep?',
      answer: 'Busca padrões em arquivos.',
    ),
    Flashcard(
      question: 'Qual comando busca padrões em arquivos?',
      answer: 'grep',
    ),

    Flashcard(
      question: 'O que faz o comando find?',
      answer: 'Busca arquivos no sistema.',
    ),
    Flashcard(
      question: 'Qual comando busca arquivos no sistema?',
      answer: 'find',
    ),

    // =====================
    // PROCESSOS
    // =====================
    Flashcard(
      question: 'O que faz o comando ps?',
      answer: 'Mostra processos em execução.',
    ),
    Flashcard(
      question: 'Qual comando mostra processos em execução?',
      answer: 'ps',
    ),

    Flashcard(
      question: 'O que faz o comando top?',
      answer: 'Mostra processos em tempo real.',
    ),
    Flashcard(
      question: 'Qual comando mostra processos em tempo real?',
      answer: 'top',
    ),

    Flashcard(
      question: 'O que faz o comando kill?',
      answer: 'Encerra processos.',
    ),
    Flashcard(question: 'Qual comando encerra processos?', answer: 'kill'),

    // =====================
    // OUTROS IMPORTANTES
    // =====================
    Flashcard(
      question: 'O que faz o pipe (|)?',
      answer: 'Encaminha saída de um comando para outro.',
    ),
    Flashcard(
      question: 'O que faz o redirecionamento >?',
      answer: 'Envia saída para um arquivo.',
    ),
    Flashcard(
      question: 'O que faz o redirecionamento >>?',
      answer: 'Adiciona saída ao final de um arquivo.',
    ),
  ],
);
