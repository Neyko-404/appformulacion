import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/shared/presentation/focus_companion_card.dart';

void main() {
  test('each appearance produces a distinct themed visual configuration', () {
    for (final brightness in Brightness.values) {
      final colors = ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: brightness,
      );
      final visuals = CompanionAppearance.values
          .map((appearance) => companionAvatarVisual(colors, appearance))
          .toList();

      expect(visuals.map((visual) => visual.badgeIcon).toSet(), hasLength(3));
      expect(
        visuals.map((visual) => visual.backgroundColor).toSet(),
        hasLength(3),
      );
      for (final visual in visuals) {
        expect(visual.backgroundColor, isNot(visual.foregroundColor));
      }
    }
  });

  testWidgets('shows name and message with semantics but no technical label', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FocusCompanionCard(
            name: 'Mitsuky',
            appearance: CompanionAppearance.emerald,
            message: 'Buen ritmo.',
          ),
        ),
      ),
    );

    expect(find.text('Mitsuky'), findsOneWidget);
    expect(find.text('Buen ritmo.'), findsOneWidget);
    expect(find.byIcon(Icons.pets_outlined), findsOneWidget);
    expect(find.byIcon(Icons.eco_outlined), findsOneWidget);
    expect(find.textContaining('apariencia'), findsNothing);
    expect(
      tester.getSemantics(find.byType(FocusCompanionCard)).label,
      contains('Mitsuky, tu compañero de estudio. Buen ritmo.'),
    );
  });
}
