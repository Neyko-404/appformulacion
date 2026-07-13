import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/presentation/cat_painter.dart';
import 'package:focusly/features/companion/presentation/companion_cat_palette.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
import 'package:focusly/features/companion/presentation/services/companion_cat_pose_mapper.dart';
import 'package:focusly/features/companion/presentation/services/companion_motion_policy.dart';
import 'package:focusly/features/companion/presentation/widgets/animated_companion_avatar.dart';

void main() {
  const customization = CompanionCustomization(
    ownerId: 'user-1',
    identity: CompanionIdentity(
      displayName: 'Mitsuky',
      selectedTheme: CompanionTheme.classic,
      selectedAvatar: CompanionAppearance.pet,
      preferredExpressionStyle: CompanionExpressionStyle.standard,
    ),
  );

  CompanionExpressionState state(
    CompanionExpression expression, {
    CompanionEmphasis emphasis = CompanionEmphasis.normal,
    CompanionContext context = CompanionContext.dashboardIdle,
  }) => CompanionExpressionState(
    context: context,
    mood: CompanionMood.relaxed,
    expression: expression,
    message: 'Mensaje seguro.',
    semanticLabel: 'Compañero tranquilo. Mensaje seguro.',
    emphasis: emphasis,
  );

  test('pose mapper is deterministic for every expression and variant', () {
    const mapper = CompanionCatPoseMapper();
    for (final expression in CompanionExpression.values) {
      for (final variant in CompanionCardVariant.values) {
        final first = mapper.map(
          state: state(expression),
          customization: customization,
          variant: variant,
        );
        expect(
          first,
          mapper.map(
            state: state(expression),
            customization: customization,
            variant: variant,
          ),
        );
        expect(first.eyeOpenness, inInclusiveRange(0, 1));
      }
    }
    final sleeping = mapper.map(
      state: state(CompanionExpression.sleeping),
      customization: customization,
    );
    expect(sleeping.blinkEnabled, isFalse);
    expect(sleeping.tailMotionEnabled, isFalse);
    final cheering = mapper.map(
      state: state(
        CompanionExpression.cheering,
        emphasis: CompanionEmphasis.celebratory,
      ),
      customization: customization,
    );
    expect(cheering.celebrationEnabled, isTrue);
  });

  test('motion policy disables movement and keeps focus discreet', () {
    final pose = const CompanionCatPoseMapper().map(
      state: state(CompanionExpression.normal),
      customization: customization,
    );
    final normal = CompanionMotionPolicy.resolve(
      pose: pose,
      context: CompanionContext.dashboardIdle,
      variant: CompanionCardVariant.standard,
      reduceMotion: false,
    );
    final focus = CompanionMotionPolicy.resolve(
      pose: pose,
      context: CompanionContext.focusRunningSteady,
      variant: CompanionCardVariant.focus,
      reduceMotion: false,
    );
    final reduced = CompanionMotionPolicy.resolve(
      pose: pose,
      context: CompanionContext.dashboardIdle,
      variant: CompanionCardVariant.standard,
      reduceMotion: true,
    );
    expect(normal.animationsEnabled, isTrue);
    expect(focus.tailAmplitude, lessThan(normal.tailAmplitude));
    expect(reduced.animationsEnabled, isFalse);
    expect(reduced.breathingAmplitude, 0);
    expect(reduced.tailAmplitude, 0);
  });

  testWidgets('palettes, painter and avatar render safely', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox();
          },
        ),
      ),
    );
    final colors = <Color>{};
    for (final theme in CompanionTheme.values) {
      colors.add(
        CompanionCatPalette.fromTheme(Theme.of(context), theme).furColor,
      );
    }
    expect(colors, hasLength(5));
    final pose = const CompanionCatPoseMapper().map(
      state: state(CompanionExpression.cheering),
      customization: customization,
    );
    final palette = CompanionCatPalette.fromTheme(
      Theme.of(context),
      CompanionTheme.classic,
    );
    final painter = CatPainter(pose: pose, palette: palette);
    expect(painter.shouldRepaint(painter), isFalse);

    const model = CompanionPresentationModel(
      displayName: 'Mitsuky',
      theme: CompanionTheme.classic,
      avatar: CompanionAppearance.pet,
      mood: CompanionMood.focused,
      expression: CompanionExpression.normal,
      message: 'Ya comenzaste.',
      semanticLabel: 'Compañero concentrado. Ya comenzaste.',
      emphasis: CompanionEmphasis.subtle,
      accentColorKey: 'classic',
      context: CompanionContext.focusRunningStart,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedCompanionAvatar(
            model: model,
            variant: CompanionCardVariant.focus,
            size: 80,
            reduceMotion: true,
            semanticLabel: 'Mitsuky, compañero concentrado.',
          ),
        ),
      ),
    );
    expect(find.byType(CustomPaint), findsWidgets);
    expect(
      find.bySemanticsLabel('Mitsuky, compañero concentrado.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      const MaterialApp(
        home: AnimatedCompanionAvatar(
          model: model,
          variant: CompanionCardVariant.standard,
          size: -1,
          semanticLabel: 'Fallback seguro',
        ),
      ),
    );
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(find.bySemanticsLabel('Fallback seguro'), findsOneWidget);
  });
}
