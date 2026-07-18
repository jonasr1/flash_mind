import 'package:flutter/material.dart';

class SrsTutorialOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const SrsTutorialOverlay({super.key, required this.onDismiss});

  @override
  State<SrsTutorialOverlay> createState() => _SrsTutorialOverlayState();
}

class _SrsTutorialOverlayState extends State<SrsTutorialOverlay> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Botão Fechar / Pular no topo direito se não for a última página
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _currentPage < _totalPages - 1
                    ? TextButton(
                        onPressed: widget.onDismiss,
                        child: Text(
                          'Pular',
                          style: TextStyle(color: colorScheme.outline),
                        ),
                      )
                    : const SizedBox(height: 48), // Mantém o espaçamento
              ),
            ),
            
            // Área de Conteúdo (PageView)
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage(
                    context,
                    icon: Icons.psychology_rounded,
                    title: 'Estude de forma inteligente',
                    content: 'O FlashMind utiliza repetição espaçada para melhorar a sua memorização de longo prazo.\n\nO aplicativo calcula automaticamente o melhor momento para você revisar cada cartão, garantindo que você estude na hora certa e poupe tempo.',
                  ),
                  _buildPage(
                    context,
                    icon: Icons.visibility_off_rounded,
                    title: 'Para onde vão meus cartões?',
                    content: 'Os cartões não desaparecem do aplicativo!\n\nEles apenas deixam a sessão de estudos atual após você respondê-los. Todo o seu progresso continua salvo em segurança e eles retornarão automaticamente no momento ideal para testar sua memória.',
                  ),
                  _buildPage(
                    context,
                    icon: Icons.rate_review_rounded,
                    title: 'O que significa cada resposta?',
                    contentWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildButtonExplanation(
                          context,
                          label: 'Não sabia',
                          color: colorScheme.error,
                          description: 'O cartão retorna rapidamente na mesma sessão para reforçar o aprendizado.',
                        ),
                        const SizedBox(height: 16),
                        _buildButtonExplanation(
                          context,
                          label: 'Difícil',
                          color: colorScheme.tertiary,
                          description: 'O cartão retorna em pouco tempo para reforçar a memória.',
                        ),
                        const SizedBox(height: 16),
                        _buildButtonExplanation(
                          context,
                          label: 'Fácil',
                          color: colorScheme.primary,
                          description: 'O cartão retorna somente depois de um intervalo maior, pois você já o domina.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Rodapé com Indicador de Páginas e Navegação
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicador de Páginas (Pontos)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _totalPages,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Botões de Ação
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botão Voltar
                      Opacity(
                        opacity: _currentPage > 0 ? 1.0 : 0.0,
                        child: TextButton(
                          onPressed: _currentPage > 0 ? _previousPage : null,
                          child: const Text('Voltar'),
                        ),
                      ),
                      
                      // Botão Avançar / Começar Revisão
                      _currentPage == _totalPages - 1
                          ? FilledButton(
                              onPressed: widget.onDismiss,
                              child: const Text('Começar revisão'),
                            )
                          : FilledButton.tonal(
                              onPressed: _nextPage,
                              child: const Text('Próximo'),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? content,
    Widget? contentWidget,
  }) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            icon,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          if (content != null)
            Text(
              content,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          if (contentWidget != null) contentWidget,
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildButtonExplanation(
    BuildContext context, {
    required String label,
    required Color color,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 90,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
