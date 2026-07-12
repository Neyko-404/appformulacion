import 'package:flutter/material.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/shared/presentation/app_spacing.dart';

final class CompanionAvatarVisual {
  const CompanionAvatarVisual({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.badgeIcon,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData badgeIcon;
}

CompanionAvatarVisual companionAvatarVisual(
  ColorScheme colors,
  CompanionAppearance appearance,
) => switch (appearance) {
  CompanionAppearance.indigo => CompanionAvatarVisual(
    backgroundColor: colors.primaryContainer,
    foregroundColor: colors.onPrimaryContainer,
    badgeIcon: Icons.auto_awesome,
  ),
  CompanionAppearance.amber => CompanionAvatarVisual(
    backgroundColor: colors.tertiaryContainer,
    foregroundColor: colors.onTertiaryContainer,
    badgeIcon: Icons.light_mode_outlined,
  ),
  CompanionAppearance.emerald => CompanionAvatarVisual(
    backgroundColor: colors.secondaryContainer,
    foregroundColor: colors.onSecondaryContainer,
    badgeIcon: Icons.eco_outlined,
  ),
};

final class FocusCompanionCard extends StatelessWidget {
  const FocusCompanionCard({
    required this.name,
    required this.message,
    required this.appearance,
    super.key,
  });

  final String name;
  final String message;
  final CompanionAppearance appearance;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final avatar = companionAvatarVisual(colors, appearance);
    return Semantics(
      container: true,
      label: '$name, tu compañero de estudio. $message',
      child: Card(
        elevation: 0,
        color: colors.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: avatar.backgroundColor,
                      foregroundColor: avatar.foregroundColor,
                      child: const Icon(Icons.pets_outlined),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Icon(
                            avatar.badgeIcon,
                            size: 14,
                            color: avatar.foregroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xSmall),
                    Text(message),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
