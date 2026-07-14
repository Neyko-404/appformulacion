import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/companion/domain/entities/companion_customization.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_presentation_model.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';
import 'package:focusly/features/companion/presentation/companion_cat_palette.dart';
import 'package:focusly/features/companion/presentation/models/cat_pose.dart';
import 'package:focusly/features/companion/presentation/models/companion_card_variant.dart';
import 'package:focusly/features/companion/presentation/services/companion_cat_pose_mapper.dart';
import 'package:focusly/features/companion/presentation/services/companion_motion_policy.dart';
import 'package:focusly/features/companion/presentation/study_cat_painter.dart';
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

    final accents = <CatAccentStyle>{};
    for (final appearance in CompanionAppearance.values) {
      accents.add(
        mapper
            .map(
              state: state(CompanionExpression.normal),
              customization: CompanionCustomization(
                ownerId: 'user-1',
                identity: CompanionIdentity(
                  displayName: 'Mitsuky',
                  selectedTheme: CompanionTheme.classic,
                  selectedAvatar: appearance,
                  preferredExpressionStyle: CompanionExpressionStyle.standard,
                ),
              ),
            )
            .accentStyle,
      );
    }
    expect(accents, hasLength(CompanionAppearance.values.length));
  });

  test('cat pose validates ranges and compares by value', () {
    final pose = const CompanionCatPoseMapper().map(
      state: state(CompanionExpression.normal),
      customization: customization,
    );
    final same = const CompanionCatPoseMapper().map(
      state: state(CompanionExpression.normal),
      customization: customization,
    );
    expect(pose, same);
    expect(pose.hashCode, same.hashCode);
    expect(
      () => CatPose(
        eyeOpenness: 1.1,
        mouthStyle: CatMouthStyle.neutral,
        earTilt: 0,
        headTilt: 0,
        bodyScale: 1,
        tailAngle: 0,
        pawLift: 0,
        verticalOffset: 0,
        blinkEnabled: true,
        breatheEnabled: true,
        tailMotionEnabled: true,
        celebrationEnabled: false,
      ),
      throwsAssertionError,
    );
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
    expect(reduced.poseTransitionDuration, Duration.zero);
    expect(
      normal.breathingDuration.inMilliseconds,
      inInclusiveRange(2500, 4000),
    );
    expect(normal.blinkDuration, lessThan(normal.blinkInterval));

    final sleeping = const CompanionCatPoseMapper().map(
      state: state(CompanionExpression.sleeping),
      customization: customization,
    );
    final sleepingMotion = CompanionMotionPolicy.resolve(
      pose: sleeping,
      context: CompanionContext.noActivity,
      variant: CompanionCardVariant.standard,
      reduceMotion: false,
    );
    expect(sleepingMotion.animationsEnabled, isFalse);
    expect(sleepingMotion.hasContinuousMotion, isFalse);
  });

  testWidgets('palettes and painter support themes and sizes', (tester) async {
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
    for (final brightness in Brightness.values) {
      final themeData = brightness == Brightness.dark
          ? ThemeData.dark()
          : ThemeData.light();
      for (final theme in CompanionTheme.values) {
        final palette = CompanionCatPalette.fromTheme(themeData, theme);
        colors.add(palette.furColor);
        expect(palette, CompanionCatPalette.fromTheme(themeData, theme));
        expect(palette.isVisible, isTrue);
        expect(
          _contrast(palette.furColor, palette.outlineColor),
          greaterThanOrEqualTo(2),
        );
        expect(palette.furColor.a, greaterThan(0));
        expect(palette.outlineColor.a, greaterThan(0));
      }
    }
    expect(colors.length, greaterThanOrEqualTo(5));
    final pose = const CompanionCatPoseMapper().map(
      state: state(CompanionExpression.cheering),
      customization: customization,
    );
    final palette = CompanionCatPalette.fromTheme(
      Theme.of(context),
      CompanionTheme.classic,
    );
    final painter = StudyCatPainter(pose: pose, palette: palette);
    expect(painter.shouldRepaint(painter), isFalse);
    expect(
      painter.shouldRepaint(
        StudyCatPainter(
          pose: const CompanionCatPoseMapper().map(
            state: state(CompanionExpression.sleeping),
            customization: customization,
          ),
          palette: palette,
        ),
      ),
      isTrue,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Row(
          children: [
            CustomPaint(size: const Size.square(32), painter: painter),
            CustomPaint(size: const Size.square(180), painter: painter),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('avatar renders semantics, fallback and reduced motion safely', (
    tester,
  ) async {
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
      tester.getSize(find.byKey(AnimatedCompanionAvatar.avatarKey)),
      const Size.square(80),
    );
    expect(
      tester.getSize(find.byKey(AnimatedCompanionAvatar.paintKey)),
      const Size.square(80),
    );
    expect(_catPainter(tester), isA<StudyCatPainter>());
    expect(
      find.bySemanticsLabel('Mitsuky, compañero concentrado.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: AnimatedCompanionAvatar(
            model: model,
            variant: CompanionCardVariant.standard,
            size: -1,
            semanticLabel: 'Fallback seguro',
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(
      tester.getSize(find.byKey(AnimatedCompanionAvatar.fallbackKey)),
      const Size.square(48),
    );
    expect(find.byKey(AnimatedCompanionAvatar.paintKey), findsNothing);
    expect(find.bySemanticsLabel('Fallback seguro'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('celebration runs once and controllers dispose safely', (
    tester,
  ) async {
    const completed = CompanionPresentationModel(
      displayName: 'Mitsuky',
      theme: CompanionTheme.sunset,
      avatar: CompanionAppearance.satisfied,
      mood: CompanionMood.celebrating,
      expression: CompanionExpression.cheering,
      message: 'Lo completaste.',
      semanticLabel: 'CompaÃ±ero celebrando. Lo completaste.',
      emphasis: CompanionEmphasis.celebratory,
      accentColorKey: 'sunset',
      context: CompanionContext.sessionCompleted,
    );
    Widget avatar() => const MaterialApp(
      home: Center(
        child: AnimatedCompanionAvatar(
          model: completed,
          variant: CompanionCardVariant.standard,
          size: 96,
          semanticLabel: 'Mitsuky celebrando',
        ),
      ),
    );

    await tester.pumpWidget(avatar());
    expect(
      tester.getSize(find.byKey(AnimatedCompanionAvatar.paintKey)),
      const Size.square(96),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      tester.getSize(find.byKey(AnimatedCompanionAvatar.paintKey)),
      const Size.square(96),
    );
    expect(_catPainter(tester).celebration, greaterThan(0));

    await tester.pumpWidget(avatar());
    await tester.pump(const Duration(milliseconds: 400));
    expect(_catPainter(tester).celebration, closeTo(0, 0.000001));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

StudyCatPainter _catPainter(WidgetTester tester) => tester
    .widgetList<CustomPaint>(find.byType(CustomPaint))
    .map((widget) => widget.painter)
    .whereType<StudyCatPainter>()
    .last;

double _contrast(Color first, Color second) {
  final bright = first.computeLuminance() + 0.05;
  final dark = second.computeLuminance() + 0.05;
  return bright > dark ? bright / dark : dark / bright;
}
