import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/presentation/widgets/companion_presence_card.dart';

void main() {
  const model = CompanionPresentationModel(
    displayName: 'Mitsuky con un nombre especialmente largo',
    theme: CompanionTheme.night,
    avatar: CompanionAppearance.nature,
    mood: CompanionMood.focused,
    expression: CompanionExpression.thinking,
    message: 'Buen ritmo.',
    semanticLabel: 'Compañero concentrado. Buen ritmo.',
    emphasis: CompanionEmphasis.subtle,
    supportingMessage: 'Continúa cuando estés listo.',
    accentColorKey: 'night',
  );

  for (final variant in CompanionCardVariant.values) {
    testWidgets('${variant.name} is accessible and responsive', (tester) async {
      tester.view.physicalSize = const Size(390, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(2),
              disableAnimations: true,
            ),
            child: Scaffold(
              body: CompanionPresenceCard(model: model, variant: variant),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Buen ritmo.'), findsOneWidget);
      expect(find.text('Continúa cuando estés listo.'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Mitsuky.*Buen ritmo')),
        findsOneWidget,
      );
    });
  }
}
