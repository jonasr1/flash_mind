import 'dart:math';
import 'package:flutter/material.dart';

class FlashcardView extends StatefulWidget {
  final String question;
  final String answer;
  final bool isAnswerVisible;
  final VoidCallback onTap;

  const FlashcardView({
    super.key,
    required this.question,
    required this.answer,
    required this.isAnswerVisible,
    required this.onTap,
  });

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isAnswerVisible) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlashcardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswerVisible != oldWidget.isAnswerVisible) {
      if (widget.isAnswerVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final isFront = angle < pi / 2;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: isFront
              ? _buildCard(context, isFront: true)
              : Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildCard(context, isFront: false),
                ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, {required bool isFront}) {
    final theme = Theme.of(context);

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isFront ? 'Pergunta' : 'Resposta',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  isFront ? widget.question : widget.answer,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (isFront) ...[
                  Icon(
                    Icons.visibility_outlined,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clique para ver a resposta',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
