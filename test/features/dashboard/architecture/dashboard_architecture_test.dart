import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final files = Directory('lib/features/dashboard')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
  final source = files.map((file) => file.readAsStringSync()).join('\n');

  test('Dashboard imports only public contracts from other features', () {
    for (final forbidden in [
      'features/analytics/data/',
      'features/analytics/presentation/',
      'features/study_engine/data/',
      'features/study_engine/presentation/',
      'features/academic_tracker/data/',
      'features/academic_tracker/presentation/',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('Dashboard owns no repository, analytics calculation, or writes', () {
    expect(source, isNot(contains('class DashboardRepository')));
    expect(source, isNot(contains('AnalyticsCalculator')));
    expect(source, isNot(contains('.save(')));
    expect(source, isNot(contains('.delete(')));
    expect(source, isNot(contains('Random(')));
  });

  test('reactive Course and Study projections are not falsely refreshed', () {
    expect(source, isNot(contains('invalidate(activeCoursesProvider)')));
    expect(source, isNot(contains('invalidate(activeStudySummaryProvider)')));
    expect(source, isNot(contains('refresh(activeCoursesProvider')));
    expect(source, isNot(contains('refresh(activeStudySummaryProvider')));
  });
}
