import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/analytics/domain/entities/study_analytics.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

final class AnalyticsCalculator {
  const AnalyticsCalculator();

  DailyStudyAnalytics daily({
    required String ownerId,
    required AnalyticsDateRange range,
    required List<StudyAnalyticsRecord> records,
    required List<Course> courses,
  }) {
    final values = _calculate(ownerId, range, records, courses);
    return DailyStudyAnalytics(
      date: range.startInclusive,
      focusedDuration: values.focused,
      completedSessions: values.completed,
      cancelledSessions: values.cancelled,
      activeSessions: values.active,
      interruptionCount: values.interruptionCount,
      interruptionDuration: values.interruptionDuration,
      mostStudiedCourse: values.mostStudied,
    );
  }

  WeeklyStudyAnalytics weekly({
    required String ownerId,
    required AnalyticsDateRange range,
    required List<StudyAnalyticsRecord> records,
    required List<Course> courses,
  }) {
    final values = _calculate(ownerId, range, records, courses);
    return WeeklyStudyAnalytics(
      weekStart: range.startInclusive,
      weekEndExclusive: range.endExclusive,
      focusedDuration: values.focused,
      completedSessions: values.completed,
      cancelledSessions: values.cancelled,
      interruptionCount: values.interruptionCount,
      interruptionDuration: values.interruptionDuration,
      averageCompletedSessionDuration: values.completed == 0
          ? Duration.zero
          : Duration(
              microseconds: values.focused.inMicroseconds ~/ values.completed,
            ),
      activeStudyDays: values.activeDays,
      mostStudiedCourse: values.mostStudied,
    );
  }

  MonthlyStudyAnalytics monthly({
    required String ownerId,
    required AnalyticsDateRange range,
    required List<StudyAnalyticsRecord> records,
    required List<Course> courses,
  }) {
    final values = _calculate(ownerId, range, records, courses);
    return MonthlyStudyAnalytics(
      monthStart: range.startInclusive,
      monthEndExclusive: range.endExclusive,
      focusedDuration: values.focused,
      completedSessions: values.completed,
      cancelledSessions: values.cancelled,
      interruptionCount: values.interruptionCount,
      interruptionDuration: values.interruptionDuration,
      activeStudyDays: values.activeDays,
      mostStudiedCourse: values.mostStudied,
    );
  }

  List<CourseStudyAnalytics> courses({
    required String ownerId,
    required AnalyticsDateRange range,
    required List<StudyAnalyticsRecord> records,
    required List<Course> courses,
  }) {
    final values = _calculate(ownerId, range, records, courses);
    return values.courseValues..sort((a, b) {
      final duration = b.focusedDuration.compareTo(a.focusedDuration);
      if (duration != 0) return duration;
      return a.courseName.toLowerCase().compareTo(b.courseName.toLowerCase());
    });
  }

  _Calculated _calculate(
    String ownerId,
    AnalyticsDateRange range,
    List<StudyAnalyticsRecord> records,
    List<Course> courses,
  ) {
    final ownedCourses = {
      for (final course in courses.where((value) => value.ownerId == ownerId))
        course.id: course,
    };
    final ownedRecords = records.where(
      (record) => record.session.ownerId == ownerId,
    );
    final relevant = ownedRecords.where(
      (record) => range.contains(_activityAt(record.session)),
    );
    var focused = Duration.zero;
    var completed = 0;
    var cancelled = 0;
    var active = 0;
    var interruptionCount = 0;
    var interruptionDuration = Duration.zero;
    final activeDays = <DateTime>{};
    final courseValues = <String, _MutableCourse>{};

    for (final interruption in ownedRecords.expand(
      (record) => record.interruptions,
    )) {
      if (!interruption.isOpen &&
          range.contains(interruption.startedAt.toLocal())) {
        interruptionCount++;
        interruptionDuration += interruption.duration;
      }
    }

    for (final record in relevant) {
      final session = record.session;
      final activityAt = _activityAt(session);
      if (session.status == StudySessionStatus.completed) {
        completed++;
        focused += session.accumulatedFocusDuration;
        activeDays.add(
          DateTime(activityAt.year, activityAt.month, activityAt.day),
        );
      } else if (session.status == StudySessionStatus.cancelled) {
        cancelled++;
      } else if (session.isActive) {
        active++;
      }

      final courseId = session.courseId;
      if (courseId == null) continue;
      final value = courseValues.putIfAbsent(
        courseId,
        () => _MutableCourse(
          id: courseId,
          name: ownedCourses[courseId]?.name ?? 'Curso no disponible',
        ),
      );
      value.lastStudiedAt =
          value.lastStudiedAt == null ||
              activityAt.isAfter(value.lastStudiedAt!)
          ? activityAt
          : value.lastStudiedAt;
      value.interruptions += record.interruptions
          .where(
            (item) => !item.isOpen && range.contains(item.startedAt.toLocal()),
          )
          .length;
      if (session.status == StudySessionStatus.completed) {
        value.completed++;
        value.focused += session.accumulatedFocusDuration;
      } else if (session.status == StudySessionStatus.cancelled) {
        value.cancelled++;
      }
    }

    final projections = courseValues.values
        .map(
          (value) => CourseStudyAnalytics(
            courseId: value.id,
            courseName: value.name,
            focusedDuration: value.focused,
            completedSessions: value.completed,
            cancelledSessions: value.cancelled,
            interruptionCount: value.interruptions,
            lastStudiedAt: value.lastStudiedAt,
          ),
        )
        .toList();
    final ranked =
        projections.where((value) => value.completedSessions > 0).toList()
          ..sort(_compareCourses);
    final winner = ranked.firstOrNull;
    return _Calculated(
      focused: focused,
      completed: completed,
      cancelled: cancelled,
      active: active,
      interruptionCount: interruptionCount,
      interruptionDuration: interruptionDuration,
      activeDays: activeDays.length,
      mostStudied: winner == null
          ? null
          : MostStudiedCourse(
              courseId: winner.courseId,
              courseName: winner.courseName,
              focusedDuration: winner.focusedDuration,
              completedSessions: winner.completedSessions,
            ),
      courseValues: projections,
    );
  }

  int _compareCourses(CourseStudyAnalytics a, CourseStudyAnalytics b) {
    final duration = b.focusedDuration.compareTo(a.focusedDuration);
    if (duration != 0) return duration;
    final sessions = b.completedSessions.compareTo(a.completedSessions);
    if (sessions != 0) return sessions;
    final recent = (b.lastStudiedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(a.lastStudiedAt ?? DateTime.fromMillisecondsSinceEpoch(0));
    if (recent != 0) return recent;
    final name = _sortName(a.courseName).compareTo(_sortName(b.courseName));
    return name != 0 ? name : a.courseId.compareTo(b.courseId);
  }

  String _sortName(String value) => value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n');

  DateTime _activityAt(StudySession session) => (switch (session.status) {
    StudySessionStatus.completed => session.completedAt ?? session.updatedAt,
    StudySessionStatus.cancelled => session.cancelledAt ?? session.updatedAt,
    _ => session.startedAt ?? session.updatedAt,
  }).toLocal();
}

final class _MutableCourse {
  _MutableCourse({required this.id, required this.name});
  final String id;
  final String name;
  Duration focused = Duration.zero;
  int completed = 0;
  int cancelled = 0;
  int interruptions = 0;
  DateTime? lastStudiedAt;
}

final class _Calculated {
  const _Calculated({
    required this.focused,
    required this.completed,
    required this.cancelled,
    required this.active,
    required this.interruptionCount,
    required this.interruptionDuration,
    required this.activeDays,
    required this.mostStudied,
    required this.courseValues,
  });
  final Duration focused;
  final int completed;
  final int cancelled;
  final int active;
  final int interruptionCount;
  final Duration interruptionDuration;
  final int activeDays;
  final MostStudiedCourse? mostStudied;
  final List<CourseStudyAnalytics> courseValues;
}
