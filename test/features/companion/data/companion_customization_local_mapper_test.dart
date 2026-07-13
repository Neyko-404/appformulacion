import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/companion/data/mappers/companion_customization_local_mapper.dart';
import 'package:focusly/features/companion/data/models/companion_customization_local_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization_failure.dart';

void main() {
  CompanionCustomizationLocalModel model({
    String theme = 'classic',
    String avatar = 'pet',
    String expression = 'standard',
  }) => CompanionCustomizationLocalModel()
    ..ownerId = 'user-1'
    ..displayName = 'Kumo'
    ..selectedTheme = theme
    ..selectedAvatar = avatar
    ..preferredExpressionStyle = expression;

  for (final entry in {
    'theme': model(theme: 'unknown'),
    'avatar': model(avatar: 'unknown'),
    'expressionStyle': model(expression: 'unknown'),
  }.entries) {
    test('unknown ${entry.key} becomes corrupted data', () {
      expect(
        () => const CompanionCustomizationLocalMapper().toDomain(entry.value),
        throwsA(
          isA<CompanionCustomizationFailure>().having(
            (failure) => failure.type,
            'type',
            CompanionCustomizationFailureType.corruptedData,
          ),
        ),
      );
    });
  }
}
