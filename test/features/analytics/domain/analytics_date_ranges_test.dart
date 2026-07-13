import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';

void main() {
  const ranges = AnalyticsDateRanges();

  test('day uses inclusive start and exclusive next day', () {
    final range = ranges.day(DateTime(2026, 7, 12, 18, 30));
    expect(range.startInclusive, DateTime(2026, 7, 12));
    expect(range.endExclusive, DateTime(2026, 7, 13));
    expect(range.contains(DateTime(2026, 7, 12)), isTrue);
    expect(range.contains(DateTime(2026, 7, 13)), isFalse);
    expect(range.endExclusive.hour, 0);
    expect(range.endExclusive.minute, 0);
    expect(range.endExclusive.isUtc, isFalse);
  });

  test('day crosses month and year with civil midnight boundaries', () {
    expect(
      ranges.day(DateTime(2026, 1, 31, 23)).endExclusive,
      DateTime(2026, 2),
    );
    expect(ranges.day(DateTime(2026, 12, 31, 23)).endExclusive, DateTime(2027));
  });

  test('week starts Monday and crosses year safely', () {
    final range = ranges.week(DateTime(2027, 1, 1));
    expect(range.startInclusive, DateTime(2026, 12, 28));
    expect(range.endExclusive, DateTime(2027, 1, 4));
  });

  test(
    'week crosses month and includes exact start but excludes exact end',
    () {
      final range = ranges.week(DateTime(2026, 8, 1));
      expect(range.startInclusive, DateTime(2026, 7, 27));
      expect(range.endExclusive, DateTime(2026, 8, 3));
      expect(range.contains(range.startInclusive), isTrue);
      expect(range.contains(range.endExclusive), isFalse);
      expect(range.endExclusive.hour, 0);
      expect(range.endExclusive.isUtc, isFalse);
    },
  );

  test(
    'civil boundaries are local and do not assume a fixed machine offset',
    () {
      final value = ranges.day(DateTime(2026, 3, 8, 12));
      expect(value.startInclusive, DateTime(2026, 3, 8));
      expect(value.endExclusive, DateTime(2026, 3, 9));
      expect(value.startInclusive.isUtc, isFalse);
      expect(value.endExclusive.isUtc, isFalse);
    },
  );

  test('month supports 28, 29, 30 and 31 day months', () {
    expect(ranges.month(DateTime(2026, 2, 10)).endExclusive, DateTime(2026, 3));
    expect(ranges.month(DateTime(2028, 2, 10)).endExclusive, DateTime(2028, 3));
    expect(ranges.month(DateTime(2026, 4, 10)).endExclusive, DateTime(2026, 5));
    expect(ranges.month(DateTime(2026, 12, 10)).endExclusive, DateTime(2027));
  });
}
