import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/analytics/presentation/widgets/analytics_widgets.dart';

void main() {
  testWidgets('weekly comparison is responsive and uses semantic theme icons', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: TrendComparisonCard.weekly(
                WeeklyTrend(
                  focusedMinutes: comparison(120, 60),
                  completedSessions: comparison(3, 2),
                  averageSessionMinutes: comparison(40, 30),
                  interruptions: comparison(1, 3),
                  activeDays: comparison(3, 2),
                  currentDominantCourse: 'Cálculo',
                  previousDominantCourse: 'Física',
                  courseTrends: [
                    CourseTrend(
                      courseId: 'course-1',
                      courseName: 'Cálculo',
                      focusedMinutes: comparison(90, 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Comparación semanal'), findsOneWidget);
    expect(find.textContaining('Curso dominante: Cálculo'), findsOneWidget);
    expect(find.text('Mayor crecimiento: Cálculo'), findsOneWidget);
    expect(find.byIcon(Icons.trending_up), findsWidgets);
    expect(find.byIcon(Icons.trending_down), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('course declines are not presented as greatest growth', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TrendComparisonCard.weekly(
            WeeklyTrend(
              focusedMinutes: comparison(10, 20),
              completedSessions: comparison(1, 2),
              averageSessionMinutes: comparison(10, 10),
              interruptions: comparison(0, 0),
              activeDays: comparison(1, 1),
              courseTrends: [
                CourseTrend(
                  courseId: 'course-1',
                  courseName: 'Física',
                  focusedMinutes: comparison(10, 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Mayor crecimiento:'), findsNothing);
  });
}

TrendComparison comparison(double current, double previous) {
  final difference = current - previous;
  return TrendComparison(
    currentValue: current,
    previousValue: previous,
    signedDifference: difference,
    absoluteDifference: difference.abs(),
    percentageVariation: previous == 0 ? null : difference / previous * 100,
    direction: difference > 0
        ? TrendDirection.up
        : difference < 0
        ? TrendDirection.down
        : TrendDirection.stable,
  );
}
