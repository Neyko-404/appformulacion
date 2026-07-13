import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';

final class CompanionVisualStyle {
  const CompanionVisualStyle({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.themeLabel,
    required this.avatarLabel,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final String themeLabel;
  final String avatarLabel;
}

abstract final class CompanionVisualMapper {
  static CompanionVisualStyle map(
    BuildContext context, {
    required CompanionTheme theme,
    required CompanionAppearance avatar,
  }) {
    final colors = Theme.of(context).colorScheme;
    final (background, foreground, themeLabel) = switch (theme) {
      CompanionTheme.classic => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'Clásico',
      ),
      CompanionTheme.forest => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
        'Bosque',
      ),
      CompanionTheme.ocean => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        'Océano',
      ),
      CompanionTheme.sunset => (
        colors.errorContainer,
        colors.onErrorContainer,
        'Atardecer',
      ),
      CompanionTheme.night => (
        colors.inverseSurface,
        colors.onInverseSurface,
        'Noche',
      ),
    };
    final (icon, avatarLabel) = switch (avatar) {
      CompanionAppearance.pet => (Icons.pets, 'Huella'),
      CompanionAppearance.pets => (Icons.cruelty_free, 'Amigo'),
      CompanionAppearance.face => (Icons.face, 'Rostro'),
      CompanionAppearance.nature => (Icons.emoji_nature, 'Naturaleza'),
      CompanionAppearance.satisfied => (Icons.sentiment_satisfied, 'Sonrisa'),
    };
    return CompanionVisualStyle(
      icon: icon,
      background: background,
      foreground: foreground,
      themeLabel: themeLabel,
      avatarLabel: avatarLabel,
    );
  }
}
