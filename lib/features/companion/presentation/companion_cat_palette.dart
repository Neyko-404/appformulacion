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

  bool get isVisible =>
      furColor.a > 0 &&
      accentColor.a > 0 &&
      eyeColor.a > 0 &&
      innerEarColor.a > 0 &&
      outlineColor.a > 0 &&
      _contrast(furColor, outlineColor) >= 2 &&
      _contrast(furColor, eyeColor) >= 2;

  factory CompanionCatPalette.fromTheme(
    ThemeData theme,
    CompanionTheme companionTheme,
  ) {
    final colors = theme.colorScheme;
    final (background, accent, foreground) = switch (companionTheme) {
      CompanionTheme.classic => (
        colors.primaryContainer,
        colors.primary,
        colors.onPrimaryContainer,
      ),
      CompanionTheme.forest => (
        colors.tertiaryContainer,
        colors.tertiary,
        colors.onTertiaryContainer,
      ),
      CompanionTheme.ocean => (
        colors.secondaryContainer,
        colors.secondary,
        colors.onSecondaryContainer,
      ),
      CompanionTheme.sunset => (
        colors.errorContainer,
        colors.error,
        colors.onErrorContainer,
      ),
      CompanionTheme.night => (
        colors.inverseSurface,
        colors.primary,
        colors.onInverseSurface,
      ),
    };
    var fur = Color.alphaBlend(accent.withValues(alpha: .28), background);
    if (_contrast(fur, background) < 1.12) {
      fur = Color.alphaBlend(foreground.withValues(alpha: .18), background);
    }
    final palette = CompanionCatPalette(
      furColor: fur,
      accentColor: accent,
      eyeColor: foreground,
      innerEarColor: Color.alphaBlend(accent.withValues(alpha: .48), fur),
      outlineColor: foreground.withValues(alpha: .88),
      shadowColor: colors.shadow.withValues(alpha: .24),
      highlightColor: Color.alphaBlend(
        colors.surface.withValues(alpha: .62),
        fur,
      ),
    );
    assert(palette.isVisible, 'Companion cat palette must remain visible.');
    return palette;
  }

  static double _contrast(Color first, Color second) {
    final firstLuminance = first.computeLuminance() + .05;
    final secondLuminance = second.computeLuminance() + .05;
    return firstLuminance > secondLuminance
        ? firstLuminance / secondLuminance
        : secondLuminance / firstLuminance;
  }

  @override
  bool operator ==(Object other) =>
      other is CompanionCatPalette &&
      other.furColor == furColor &&
      other.accentColor == accentColor &&
      other.eyeColor == eyeColor &&
      other.innerEarColor == innerEarColor &&
      other.outlineColor == outlineColor &&
      other.shadowColor == shadowColor &&
      other.highlightColor == highlightColor;

  @override
  int get hashCode => Object.hash(
    furColor,
    accentColor,
    eyeColor,
    innerEarColor,
    outlineColor,
    shadowColor,
    highlightColor,
  );
}
