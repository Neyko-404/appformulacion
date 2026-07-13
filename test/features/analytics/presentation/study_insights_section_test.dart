import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/domain/entities/study_insight.dart';
import 'package:focusly/features/analytics/insights_public_widgets.dart';

void main() {
  testWidgets('section limits items and supports dark mode and large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final collection = InsightCollection([
      insight('one', 'Primero'),
      insight('two', 'Segundo'),
      insight('three', 'Tercero'),
    ]);
    InsightAction? selected;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: StudyInsightsSection(
                title: 'Recomendaciones',
                collection: collection,
                maxItems: 2,
                onAction: (value) => selected = value,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Primero'), findsOneWidget);
    expect(find.text('Segundo'), findsOneWidget);
    expect(find.text('Tercero'), findsNothing);
    expect(find.bySemanticsLabel(RegExp('Recomendaciones')), findsOneWidget);
    await tester.tap(find.text('Ver progreso').first);
    expect(selected, InsightAction.reviewProgress);
    expect(tester.takeException(), isNull);
  });
}

StudyInsight insight(String id, String title) => StudyInsight(
  id: id,
  category: InsightCategory.progress,
  priority: InsightPriority.medium,
  title: title,
  message: 'Mensaje neutral para el estudiante.',
  action: InsightAction.reviewProgress,
  createdFromRule: 'test_rule',
);
