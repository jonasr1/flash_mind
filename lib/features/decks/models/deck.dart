import 'package:flash_mind/features/flashcards/models/flashcard.dart';

class Deck {
  final String id;
  final String title;
  final String description;
  final List<Flashcard> flashcards;
  final DateTime createdAt;
  final DateTime updatedAt;

  Deck({
    String? id,
    required this.title,
    this.description = '',
    required this.flashcards,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'flashcards': flashcards.map((f) => f.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      flashcards: (json['flashcards'] as List)
          .map((f) => Flashcard.fromJson(f))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  int get totalCards => flashcards.length;

  int get reviewedCards {
    final now = DateTime.now();
    return flashcards.where((card) => card.nextReviewAt.isAfter(now)).length;
  }

  double get progress {
    if (totalCards == 0) return 0;
    return reviewedCards / totalCards;
  }

  Deck copyWith({
    String? title,
    String? description,
    List<Flashcard>? flashcards,
    DateTime? updatedAt,
  }) {
    return Deck(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      flashcards: flashcards ?? this.flashcards,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
