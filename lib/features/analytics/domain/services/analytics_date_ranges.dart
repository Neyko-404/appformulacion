final class AnalyticsDateRange {
  const AnalyticsDateRange(this.startInclusive, this.endExclusive);

  final DateTime startInclusive;
  final DateTime endExclusive;

  bool contains(DateTime value) =>
      !value.isBefore(startInclusive) && value.isBefore(endExclusive);
}

abstract interface class AnalyticsClock {
  DateTime now();
}

final class SystemAnalyticsClock implements AnalyticsClock {
  const SystemAnalyticsClock();

  @override
  DateTime now() => DateTime.now();
}

final class AnalyticsDateRanges {
  const AnalyticsDateRanges();

  AnalyticsDateRange day(DateTime localNow) {
    final start = DateTime(localNow.year, localNow.month, localNow.day);
    final end = DateTime(localNow.year, localNow.month, localNow.day + 1);
    return AnalyticsDateRange(start, end);
  }

  AnalyticsDateRange week(DateTime localNow) {
    final dayStart = day(localNow).startInclusive;
    final start = dayStart.subtract(Duration(days: localNow.weekday - 1));
    final end = DateTime(start.year, start.month, start.day + 7);
    return AnalyticsDateRange(start, end);
  }

  AnalyticsDateRange month(DateTime localNow) {
    final start = DateTime(localNow.year, localNow.month, 1);
    return AnalyticsDateRange(
      start,
      DateTime(localNow.year, localNow.month + 1, 1),
    );
  }
}
