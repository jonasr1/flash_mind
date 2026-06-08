import 'package:flash_mind/features/decks/models/deck.dart';
import 'package:flash_mind/features/flashcards/models/flashcard.dart';

final Deck oopDeck = Deck(
  title: 'POO',
  flashcards: [
    Flashcard(
      question: 'O que é uma classe?',
      answer: 'Um modelo para criação de objetos.',
    ),

    Flashcard(
      question:
          'Qual conceito da POO funciona como um molde para criar objetos?',
      answer: 'Classe.',
    ),
    Flashcard(
      question: 'O que é um objeto?',
      answer: 'Uma instância criada a partir de uma classe.',
    ),

    Flashcard(
      question: 'O que é criado a partir de uma classe?',
      answer: 'Um objeto.',
    ),
    Flashcard(
      question: 'O que é um atributo?',
      answer: 'Uma característica ou dado de um objeto.',
    ),

    Flashcard(
      question: 'Nome e idade de uma Pessoa são exemplos de quê?',
      answer: 'Atributos.',
    ),
    Flashcard(
      question: 'O que é um método?',
      answer: 'Uma ação ou comportamento definido em uma classe.',
    ),

    Flashcard(
      question: 'Calcular salário de um funcionário é exemplo de quê?',
      answer: 'Método.',
    ),
    Flashcard(
      question: 'O que é encapsulamento?',
      answer: 'Ocultar detalhes internos e controlar o acesso aos dados.',
    ),

    Flashcard(
      question:
          'Qual princípio da POO protege os dados contra modificações indevidas?',
      answer: 'Encapsulamento.',
    ),

    Flashcard(
      question: 'Getters e setters estão associados a qual conceito?',
      answer: 'Encapsulamento.',
    ),
    Flashcard(
      question: 'O que é herança?',
      answer:
          'Mecanismo que permite reutilizar características de outra classe.',
    ),

    Flashcard(
      question: 'Qual conceito promove reutilização de código entre classes?',
      answer: 'Herança.',
    ),

    Flashcard(
      question: 'Cachorro herdando características de Animal é exemplo de quê?',
      answer: 'Herança.',
    ),
    Flashcard(
      question: 'O que é polimorfismo?',
      answer:
          'Capacidade de usar a mesma interface para comportamentos diferentes.',
    ),

    Flashcard(
      question:
          'Qual conceito permite que objetos diferentes respondam à mesma operação de formas distintas?',
      answer: 'Polimorfismo.',
    ),

    Flashcard(
      question:
          'Uma variável Animal apontando para um Cachorro é exemplo de quê?',
      answer: 'Polimorfismo.',
    ),
    Flashcard(
      question: 'O que é abstração?',
      answer: 'Representar apenas características essenciais.',
    ),

    Flashcard(
      question:
          'Qual conceito reduz a complexidade escondendo detalhes desnecessários?',
      answer: 'Abstração.',
    ),
    Flashcard(
      question: 'O que é associação?',
      answer: 'Relacionamento entre objetos independentes.',
    ),

    Flashcard(
      question:
          'Professor e Curso podem existir separadamente. Que relacionamento é esse?',
      answer: 'Associação.',
    ),
    Flashcard(
      question: 'O que é composição?',
      answer: 'Relação em que a parte não existe sem o todo.',
    ),

    Flashcard(
      question:
          'Se o objeto principal for destruído, as partes também são destruídas. Que relacionamento é esse?',
      answer: 'Composição.',
    ),

    Flashcard(
      question:
          'Casa e quarto são frequentemente usados para exemplificar qual relacionamento?',
      answer: 'Composição.',
    ),
    Flashcard(
      question: 'O que é agregação?',
      answer: 'Relação em que as partes podem existir sem o todo.',
    ),

    Flashcard(
      question:
          'Equipe e funcionário costumam exemplificar qual relacionamento?',
      answer: 'Agregação.',
    ),

    Flashcard(
      question:
          'Se o objeto principal for removido e as partes continuarem existindo, qual relacionamento está sendo representado?',
      answer: 'Agregação.',
    ),
    Flashcard(
      question: 'Qual a diferença entre classe e objeto?',
      answer: 'Classe é o modelo; objeto é a instância criada a partir dele.',
    ),

    Flashcard(
      question: 'Qual a diferença entre atributo e método?',
      answer: 'Atributo armazena dados; método define comportamentos.',
    ),

    Flashcard(
      question: 'Qual a diferença entre abstração e encapsulamento?',
      answer: 'Abstração esconde complexidade; encapsulamento protege dados.',
    ),

    Flashcard(
      question: 'Qual a diferença entre agregação e composição?',
      answer:
          'Na agregação as partes existem separadamente; na composição não.',
    ),

    Flashcard(
      question: 'Qual a diferença entre associação e composição?',
      answer:
          'Associação representa relacionamento; composição representa dependência de existência.',
    ),
  ],
);
