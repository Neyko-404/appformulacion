enum CompanionTheme { classic, forest, ocean, sunset, night }

enum CompanionAppearance { pet, pets, face, nature, satisfied }

enum CompanionExpressionStyle { standard, soft, expressive }

final class CompanionIdentity {
  const CompanionIdentity({
    required this.displayName,
    required this.selectedTheme,
    required this.selectedAvatar,
    required this.preferredExpressionStyle,
  });

  final String displayName;
  final CompanionTheme selectedTheme;
  final CompanionAppearance selectedAvatar;
  final CompanionExpressionStyle preferredExpressionStyle;
}

final class CompanionCustomization {
  const CompanionCustomization({required this.ownerId, required this.identity});

  final String ownerId;
  final CompanionIdentity identity;

  static CompanionCustomization defaults({
    required String ownerId,
    required String displayName,
  }) => CompanionCustomization(
    ownerId: ownerId,
    identity: CompanionIdentity(
      displayName: displayName,
      selectedTheme: CompanionTheme.classic,
      selectedAvatar: CompanionAppearance.pet,
      preferredExpressionStyle: CompanionExpressionStyle.standard,
    ),
  );
}
