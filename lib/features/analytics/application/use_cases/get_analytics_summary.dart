import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/failures/analytics_failure.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_calculator.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/analytics/domain/services/trend_calculator.dart';

final class GetAnalyticsSummary {
  const GetAnalyticsSummary({
    required this.repository,
    required this.clock,
    this.calculator = const AnalyticsCalculator(),
    this.ranges = const AnalyticsDateRanges(),
    this.trendCalculator = const TrendCalculator(),
  });

  final AnalyticsRepository repository;
  final AnalyticsClock clock;
  final AnalyticsCalculator calculator;
  final AnalyticsDateRanges ranges;
  final TrendCalculator trendCalculator;

  Future<StudyAnalyticsSummary> call(String? ownerId) async {
    if (ownerId == null || ownerId.trim().isEmpty) {
      throw AnalyticsFailure.unauthenticated();
    }
    final source = await repository.read(ownerId);
    final now = clock.now().toLocal();
    final day = ranges.day(now);
    final week = ranges.week(now);
    final month = ranges.month(now);
    final previousWeek = ranges.week(
      DateTime(
        week.startInclusive.year,
        week.startInclusive.month,
        week.startInclusive.day - 1,
      ),
    );
    final previousMonth = ranges.month(
      DateTime(month.startInclusive.year, month.startInclusive.month - 1, 1),
    );
    final weekly = calculator.weekly(
      ownerId: ownerId,
      range: week,
      records: source.records,
      courses: source.courses,
    );
    final monthly = calculator.monthly(
      ownerId: ownerId,
      range: month,
      records: source.records,
      courses: source.courses,
    );
    final previousWeekly = calculator.weekly(
      ownerId: ownerId,
      range: previousWeek,
      records: source.records,
      courses: source.courses,
    );
    final previousMonthly = calculator.monthly(
      ownerId: ownerId,
      range: previousMonth,
      records: source.records,
      courses: source.courses,
    );
    final currentWeekCourses = calculator.courses(
      ownerId: ownerId,
      range: week,
      records: source.records,
      courses: source.courses,
    );
    final currentMonthCourses = calculator.courses(
      ownerId: ownerId,
      range: month,
      records: source.records,
      courses: source.courses,
    );
    return StudyAnalyticsSummary(
      daily: calculator.daily(
        ownerId: ownerId,
        range: day,
        records: source.records,
        courses: source.courses,
      ),
      weekly: weekly,
      monthly: monthly,
      courses: currentMonthCourses,
      trends: trendCalculator.calculate(
        currentWeek: weekly,
        previousWeek: previousWeekly,
        currentMonth: monthly,
        previousMonth: previousMonthly,
        currentWeekCourses: currentWeekCourses,
        previousWeekCourses: calculator.courses(
          ownerId: ownerId,
          range: previousWeek,
          records: source.records,
          courses: source.courses,
        ),
        currentMonthCourses: currentMonthCourses,
        previousMonthCourses: calculator.courses(
          ownerId: ownerId,
          range: previousMonth,
          records: source.records,
          courses: source.courses,
        ),
      ),
    );
  }
}
