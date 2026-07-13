import 'package:focusly/features/companion/data/models/companion_customization_local_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization_failure.dart';

final class CompanionCustomizationLocalMapper {
  const CompanionCustomizationLocalMapper();

  CompanionCustomization toDomain(CompanionCustomizationLocalModel model) {
    if (model.ownerId.trim().isEmpty) {
      throw CompanionCustomizationFailure.corruptedData();
    }
    return CompanionCustomization(
      ownerId: model.ownerId,
      identity: CompanionIdentity(
        displayName: model.displayName,
        selectedTheme: _theme(model.selectedTheme),
        selectedAvatar: _avatar(model.selectedAvatar),
        preferredExpressionStyle: _expression(model.preferredExpressionStyle),
      ),
    );
  }

  CompanionTheme _theme(String value) => switch (value) {
    'classic' => CompanionTheme.classic,
    'forest' => CompanionTheme.forest,
    'ocean' => CompanionTheme.ocean,
    'sunset' => CompanionTheme.sunset,
    'night' => CompanionTheme.night,
    _ => throw CompanionCustomizationFailure.corruptedData(),
  };

  CompanionAppearance _avatar(String value) => switch (value) {
    'pet' => CompanionAppearance.pet,
    'pets' => CompanionAppearance.pets,
    'face' => CompanionAppearance.face,
    'nature' => CompanionAppearance.nature,
    'satisfied' => CompanionAppearance.satisfied,
    _ => throw CompanionCustomizationFailure.corruptedData(),
  };

  CompanionExpressionStyle _expression(String value) => switch (value) {
    'standard' => CompanionExpressionStyle.standard,
    'soft' => CompanionExpressionStyle.soft,
    'expressive' => CompanionExpressionStyle.expressive,
    _ => throw CompanionCustomizationFailure.corruptedData(),
  };
}
