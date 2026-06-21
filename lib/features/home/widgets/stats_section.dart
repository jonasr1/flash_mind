import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'onboarding_tooltip.dart';

import '../models/stats_data.dart';

class StatsSection extends StatelessWidget {
  final StatsData stats;
  final GlobalKey? availableCardsKey;

  const StatsSection({super.key, required this.stats, this.availableCardsKey});

  Widget buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    GlobalKey? showcaseKey,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (showcaseKey != null) {
      cardContent = Showcase.withWidget(
        scope: 'home',
        key: showcaseKey,
        targetShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        container: OnboardingTooltip(
          title: 'Cards Disponíveis Hoje',
          description:
              'Aqui você vê quantos cards estão prontos para revisão neste momento.',
          currentStep: 1,
          totalSteps: 3,
          onNext: () => ShowcaseView.getNamed('home').next(),
          onSkip: () => ShowcaseView.getNamed('home').dismiss(),
        ),
        child: cardContent,
      );
    }

    return Expanded(child: cardContent);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            buildCard(
              context,
              icon: Icons.local_fire_department_rounded,
              title: 'Sequência',
              value:
                  '${stats.streakDays} ${stats.streakDays == 1 ? 'dia' : 'dias'}',
            ),
            const SizedBox(width: 16),
            buildCard(
              context,
              icon: Icons.style,
              title: 'Cards Estudados',
              value: '${stats.uniqueCardsReviewedToday}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            buildCard(
              context,
              icon: Icons.loop_rounded,
              title: 'Revisões Feitas',
              value: '${stats.reviewsToday}',
            ),
            const SizedBox(width: 16),
            buildCard(
              context,
              icon: Icons.alarm_rounded,
              title: 'Cards Disponíveis',
              value: '${stats.availableCards}',
              showcaseKey: availableCardsKey,
            ),
          ],
        ),
      ],
    );
  }
}
