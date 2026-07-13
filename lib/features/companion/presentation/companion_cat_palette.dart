import 'package:flutter/material.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';

final class CompanionCatPalette {
  const CompanionCatPalette({
    required this.furColor,
    required this.accentColor,
    required this.eyeColor,
    required this.innerEarColor,
    required this.outlineColor,
    required this.shadowColor,
    required this.highlightColor,
  });

  final Color furColor;
  final Color accentColor;
  final Color eyeColor;
  final Color innerEarColor;
  final Color outlineColor;
  final Color shadowColor;
  final Color highlightColor;

  factory CompanionCatPalette.fromTheme(
    ThemeData theme,
    CompanionTheme companionTheme,
  ) {
    final colors = theme.colorScheme;
    final (fur, accent) = switch (companionTheme) {
      CompanionTheme.classic => (colors.primaryContainer, colors.primary),
      CompanionTheme.forest => (colors.tertiaryContainer, colors.tertiary),
      CompanionTheme.ocean => (colors.secondaryContainer, colors.secondary),
      CompanionTheme.sunset => (colors.errorContainer, colors.error),
      CompanionTheme.night => (colors.inverseSurface, colors.primary),
    };
    final foreground =
        ThemeData.estimateBrightnessForColor(fur) == Brightness.dark
        ? Colors.white
        : Colors.black87;
    return CompanionCatPalette(
      furColor: fur,
      accentColor: accent,
      eyeColor: foreground,
      innerEarColor: Color.alphaBlend(accent.withValues(alpha: .28), fur),
      outlineColor: foreground.withValues(alpha: .72),
      shadowColor: colors.shadow.withValues(alpha: .18),
      highlightColor: colors.surface.withValues(alpha: .7),
    );
  }
}
