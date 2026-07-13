import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/failures/analytics_failure.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_calculator.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';

final class GetAnalyticsSummary {
  const GetAnalyticsSummary({
    required this.repository,
    required this.clock,
    this.calculator = const AnalyticsCalculator(),
    this.ranges = const AnalyticsDateRanges(),
  });

  final AnalyticsRepository repository;
  final AnalyticsClock clock;
  final AnalyticsCalculator calculator;
  final AnalyticsDateRanges ranges;

  Future<StudyAnalyticsSummary> call(String? ownerId) async {
    if (ownerId == null || ownerId.trim().isEmpty) {
      throw AnalyticsFailure.unauthenticated();
    }
    final source = await repository.read(ownerId);
    final now = clock.now().toLocal();
    final day = ranges.day(now);
    final week = ranges.week(now);
    final month = ranges.month(now);
    return StudyAnalyticsSummary(
      daily: calculator.daily(
        ownerId: ownerId,
        range: day,
        records: source.records,
        courses: source.courses,
      ),
      weekly: calculator.weekly(
        ownerId: ownerId,
        range: week,
        records: source.records,
        courses: source.courses,
      ),
      monthly: calculator.monthly(
        ownerId: ownerId,
        range: month,
        records: source.records,
        courses: source.courses,
      ),
      courses: calculator.courses(
        ownerId: ownerId,
        range: month,
        records: source.records,
        courses: source.courses,
      ),
    );
  }
}
