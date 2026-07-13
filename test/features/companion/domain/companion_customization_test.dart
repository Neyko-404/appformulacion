import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/companion/data/repositories/in_memory_companion_customization_repository.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/domain/services/companion_presentation_mapper.dart';

void main() {
  const identity = CompanionIdentity(
    displayName: 'Lumi',
    selectedTheme: CompanionTheme.ocean,
    selectedAvatar: CompanionAppearance.nature,
    preferredExpressionStyle: CompanionExpressionStyle.soft,
  );
  const customization = CompanionCustomization(
    ownerId: 'user-1',
    identity: identity,
  );

  test('customization contains visual identity but no derived state', () {
    expect(customization.ownerId, 'user-1');
    expect(customization.identity.displayName, 'Lumi');
    expect(CompanionTheme.values, hasLength(5));
    expect(CompanionAppearance.values, hasLength(5));
  });

  test(
    'presentation mapper preserves snapshot behavior and applies identity',
    () {
      const snapshot = CompanionSnapshot(
        mood: CompanionMood.focused,
        expression: CompanionExpression.thinking,
        progress: CompanionProgress(
          focusMinutesToday: 25,
          completedSessionsToday: 1,
          activeDays: 2,
          weeklyTrend: TrendDirection.up,
        ),
        message: 'Sigamos cuando quieras.',
      );
      final model = const CompanionPresentationMapper().map(
        snapshot: snapshot,
        customization: customization,
      );
      expect(model.displayName, 'Lumi');
      expect(model.theme, CompanionTheme.ocean);
      expect(model.avatar, CompanionAppearance.nature);
      expect(model.mood, snapshot.mood);
      expect(model.expression, snapshot.expression);
      expect(model.message, snapshot.message);
      expect(model.accentColorKey, 'ocean');
    },
  );

  test(
    'in-memory persistence separates users and replaces customization',
    () async {
      final repository = InMemoryCompanionCustomizationRepository();
      await repository.save(customization);
      await repository.save(
        CompanionCustomization.defaults(ownerId: 'user-2', displayName: 'Milo'),
      );
      await repository.save(
        const CompanionCustomization(
          ownerId: 'user-1',
          identity: CompanionIdentity(
            displayName: 'Nova',
            selectedTheme: CompanionTheme.night,
            selectedAvatar: CompanionAppearance.face,
            preferredExpressionStyle: CompanionExpressionStyle.soft,
          ),
        ),
      );
      expect((await repository.get('user-1'))?.identity.displayName, 'Nova');
      expect((await repository.get('user-2'))?.identity.displayName, 'Milo');
    },
  );
}
