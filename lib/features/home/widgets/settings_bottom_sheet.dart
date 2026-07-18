import 'package:flutter/material.dart';
import 'package:flash_mind/main.dart';

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  Widget _buildThemeOption(
    BuildContext context, {
    required ThemeMode mode,
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_rounded, color: colorScheme.primary)
          : null,
      onTap: () {
        FlashcardApp.of(context).changeThemeMode(mode);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentMode = FlashcardApp.of(context).themeMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Configurações',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalize sua experiência no aplicativo.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            'Tema do Aplicativo',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          _buildThemeOption(
            context,
            mode: ThemeMode.system,
            label: 'Seguir o sistema',
            icon: Icons.brightness_auto_rounded,
            isSelected: currentMode == ThemeMode.system,
          ),
          _buildThemeOption(
            context,
            mode: ThemeMode.light,
            label: 'Tema claro',
            icon: Icons.light_mode_rounded,
            isSelected: currentMode == ThemeMode.light,
          ),
          _buildThemeOption(
            context,
            mode: ThemeMode.dark,
            label: 'Tema escuro',
            icon: Icons.dark_mode_rounded,
            isSelected: currentMode == ThemeMode.dark,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

void showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => const SettingsBottomSheet(),
  );
}
