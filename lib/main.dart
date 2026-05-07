import 'package:flash_mind/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: const Center(child: Text('Home')),
    );
  }
}
