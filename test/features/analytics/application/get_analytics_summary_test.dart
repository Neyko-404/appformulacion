import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/application/use_cases/get_analytics_summary.dart';
import 'package:focusly/features/analytics/domain/failures/analytics_failure.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';

void main() {
  test('uses injected clock for daily weekly and monthly summary', () async {
    final useCase = GetAnalyticsSummary(
      repository: const _Repository(),
      clock: _Clock(DateTime(2026, 7, 12, 10)),
    );
    final value = await useCase('user-1');
    expect(value.daily.date, DateTime(2026, 7, 12));
    expect(value.weekly.weekStart, DateTime(2026, 7, 6));
    expect(value.monthly.monthStart, DateTime(2026, 7));
  });

  test('unauthenticated owner is rejected before reading sources', () async {
    final useCase = GetAnalyticsSummary(
      repository: const _Repository(),
      clock: _Clock(DateTime(2026)),
    );
    await expectLater(useCase(null), throwsA(isA<AnalyticsFailure>()));
  });
}

final class _Clock implements AnalyticsClock {
  _Clock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

final class _Repository implements AnalyticsRepository {
  const _Repository();
  @override
  Future<AnalyticsSourceSnapshot> read(String ownerId) async =>
      const AnalyticsSourceSnapshot(records: [], courses: []);
}
