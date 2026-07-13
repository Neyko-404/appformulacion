import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/analytics/domain/services/analytics_calculator.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

void main() {
  const calculator = AnalyticsCalculator();
  final range = AnalyticsDateRange(DateTime(2026, 7, 1), DateTime(2026, 8));

  test('empty sources produce zero metrics', () {
    final value = calculator.monthly(
      ownerId: 'user-1',
      range: range,
      records: const [],
      courses: const [],
    );
    expect(value.focusedDuration, Duration.zero);
    expect(value.completedSessions, 0);
    expect(value.activeStudyDays, 0);
  });

  test('completed time, statuses, averages and interruptions are distinct', () {
    final records = [
      _record(
        'completed-1',
        StudySessionStatus.completed,
        25,
        day: 2,
        interruptions: 1,
      ),
      _record('completed-2', StudySessionStatus.completed, 35, day: 3),
      _record('cancelled', StudySessionStatus.cancelled, 20, day: 3),
      _record('running', StudySessionStatus.running, 10, day: 4),
      _record('paused', StudySessionStatus.paused, 5, day: 4),
    ];
    final weekly = calculator.weekly(
      ownerId: 'user-1',
      range: range,
      records: records,
      courses: [_course('course-a', 'Álgebra')],
    );
    final daily = calculator.daily(
      ownerId: 'user-1',
      range: range,
      records: records,
      courses: [_course('course-a', 'Álgebra')],
    );
    expect(weekly.focusedDuration, const Duration(minutes: 60));
    expect(weekly.completedSessions, 2);
    expect(weekly.cancelledSessions, 1);
    expect(weekly.averageCompletedSessionDuration, const Duration(minutes: 30));
    expect(weekly.activeStudyDays, 2);
    expect(weekly.interruptionCount, 1);
    expect(weekly.interruptionDuration, const Duration(seconds: 6));
    expect(daily.activeSessions, 2);
  });

  test(
    'isolates owners, dates and counts free sessions without ranking them',
    () {
      final values = [
        _record('free', StudySessionStatus.completed, 20, day: 2, free: true),
        _record(
          'other',
          StudySessionStatus.completed,
          90,
          day: 2,
          ownerId: 'user-2',
        ),
        _record('outside', StudySessionStatus.completed, 90, day: 31, month: 8),
      ];
      final result = calculator.monthly(
        ownerId: 'user-1',
        range: range,
        records: values,
        courses: const [],
      );
      expect(result.focusedDuration, const Duration(minutes: 20));
      expect(result.completedSessions, 1);
      expect(result.mostStudiedCourse, isNull);
    },
  );

  test(
    'course winner uses duration, sessions, recency, name and id tie breaks',
    () {
      final courses = [
        _course('course-b', 'Biología'),
        _course('course-a', 'Álgebra'),
      ];
      final records = [
        _record(
          'a-1',
          StudySessionStatus.completed,
          30,
          day: 2,
          courseId: 'course-a',
        ),
        _record(
          'b-1',
          StudySessionStatus.completed,
          30,
          day: 2,
          courseId: 'course-b',
        ),
      ];
      final result = calculator.monthly(
        ownerId: 'user-1',
        range: range,
        records: records,
        courses: courses,
      );
      expect(result.mostStudiedCourse?.courseName, 'Álgebra');
    },
  );

  test('archived and unavailable courses remain safe projections', () {
    final archived = _course(
      'archived',
      'Historia',
      status: CourseStatus.archived,
    );
    final values = calculator.courses(
      ownerId: 'user-1',
      range: range,
      records: [
        _record(
          'known',
          StudySessionStatus.completed,
          10,
          day: 2,
          courseId: archived.id,
        ),
        _record(
          'deleted',
          StudySessionStatus.completed,
          5,
          day: 3,
          courseId: 'deleted',
        ),
      ],
      courses: [archived],
    );
    expect(values.any((value) => value.courseName == 'Historia'), isTrue);
    expect(
      values.any((value) => value.courseName == 'Curso no disponible'),
      isTrue,
    );
  });
}

StudyAnalyticsRecord _record(
  String id,
  StudySessionStatus status,
  int minutes, {
  int day = 1,
  int month = 7,
  int interruptions = 0,
  String ownerId = 'user-1',
  String? courseId = 'course-a',
  bool free = false,
}) {
  final at = DateTime(2026, month, day, 12);
  return StudyAnalyticsRecord(
    session: StudySession(
      id: id,
      ownerId: ownerId,
      courseId: free ? null : courseId,
      mode: StudyMode.focus,
      status: status,
      plannedDuration: Duration(minutes: minutes),
      accumulatedFocusDuration: Duration(minutes: minutes),
      startedAt: at,
      plannedEndAt: status == StudySessionStatus.running
          ? at.add(Duration(minutes: minutes))
          : null,
      pausedAt: status == StudySessionStatus.paused ? at : null,
      completedAt: status == StudySessionStatus.completed ? at : null,
      cancelledAt: status == StudySessionStatus.cancelled ? at : null,
      createdAt: at,
      updatedAt: at,
    ),
    interruptions: List.generate(
      interruptions,
      (index) => StudyInterruption(
        id: '$id-int-$index',
        startedAt: at,
        endedAt: at.add(const Duration(seconds: 6)),
        reason: StudyInterruptionReason.appBackgrounded,
        createdAt: at,
      ),
    ),
  );
}

Course _course(
  String id,
  String name, {
  CourseStatus status = CourseStatus.active,
}) {
  final at = DateTime(2026, 1, 1);
  return Course(
    id: id,
    ownerId: 'user-1',
    name: name,
    visualIdentity: CourseVisualIdentity.ocean,
    status: status,
    createdAt: at,
    updatedAt: at,
  );
}
