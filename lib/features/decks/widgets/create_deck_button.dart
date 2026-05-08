import 'package:flutter/material.dart';

class CreateDeckButton extends StatelessWidget {
  const CreateDeckButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Criar novo baralho'),
          ),
        ),
      ),
    );
  }
}