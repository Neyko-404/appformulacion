import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';

final class CompanionVisualStyle {
  const CompanionVisualStyle({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.themeLabel,
    required this.avatarLabel,
    required this.expressionIcon,
    required this.border,
    required this.iconSize,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final String themeLabel;
  final String avatarLabel;
  final IconData expressionIcon;
  final Color border;
  final double iconSize;
}

abstract final class CompanionVisualMapper {
  static CompanionVisualStyle map(
    BuildContext context, {
    required CompanionTheme theme,
    required CompanionAppearance avatar,
    CompanionExpression expression = CompanionExpression.normal,
    CompanionEmphasis emphasis = CompanionEmphasis.normal,
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
      expressionIcon: switch (expression) {
        CompanionExpression.normal => Icons.sentiment_satisfied_outlined,
        CompanionExpression.happy => Icons.sentiment_very_satisfied_outlined,
        CompanionExpression.thinking => Icons.psychology_outlined,
        CompanionExpression.cheering => Icons.celebration_outlined,
        CompanionExpression.sleeping => Icons.bedtime_outlined,
      },
      border: emphasis == CompanionEmphasis.celebratory
          ? colors.primary
          : colors.outlineVariant,
      iconSize: switch (emphasis) {
        CompanionEmphasis.subtle => 44,
        CompanionEmphasis.normal => 48,
        CompanionEmphasis.celebratory => 52,
      },
    );
  }
}
