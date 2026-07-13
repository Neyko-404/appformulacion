import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/dashboard/presentation/models/dashboard_insight.dart';
import 'package:focusly/features/dashboard/presentation/services/dashboard_insight_service.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

void main() {
  const service = DashboardInsightService();

  DashboardInsightInput input({
    StudySessionStatus? status,
    bool hasCourses = true,
    int completed = 0,
    int interruptions = 0,
    int focusedMinutes = 0,
    PrimaryGoal goal = PrimaryGoal.concentration,
    bool analyticsAvailable = true,
    bool coursesAvailable = true,
  }) => DashboardInsightInput(
    focusedDurationToday: Duration(minutes: focusedMinutes),
    completedSessionsToday: completed,
    activeSessionStatus: status,
    interruptionCountToday: interruptions,
    preferredFocusMinutes: 25,
    primaryGoal: goal,
    hasCourses: hasCourses,
    analyticsAvailable: analyticsAvailable,
    coursesAvailable: coursesAvailable,
  );

  test('running and paused sessions have the highest priority', () {
    expect(
      service.select(input(status: StudySessionStatus.running)).actionType,
      DashboardInsightAction.continueFocus,
    );
    expect(
      service.select(input(status: StudySessionStatus.paused)).title,
      'Tu sesión está en pausa',
    );
    expect(
      service
          .select(
            input(
              status: StudySessionStatus.running,
              hasCourses: false,
              interruptions: 10,
            ),
          )
          .title,
      'Tu sesión sigue en curso',
    );
  });

  test('no courses precedes no activity', () {
    final value = service.select(input(hasCourses: false));
    expect(value.actionType, DashboardInsightAction.openCourses);
  });

  test('unknown secondary sources produce a neutral insight', () {
    for (final source in [
      input(analyticsAvailable: false),
      input(coursesAvailable: false),
      input(analyticsAvailable: false, coursesAvailable: false),
    ]) {
      final value = service.select(source);
      expect(value.title, 'Preparando tu resumen');
      expect(value.actionType, DashboardInsightAction.none);
      expect(value.tone, DashboardInsightTone.neutral);
    }
  });

  test('active session precedes unavailable secondary sources', () {
    for (final status in [
      StudySessionStatus.running,
      StudySessionStatus.paused,
    ]) {
      expect(
        service
            .select(
              input(
                status: status,
                analyticsAvailable: false,
                coursesAvailable: false,
              ),
            )
            .actionType,
        DashboardInsightAction.continueFocus,
      );
    }
  });

  test('no activity suggests a short session without judgment', () {
    final value = service.select(input());
    expect(value.actionType, DashboardInsightAction.startFocus);
    expect(value.message, contains('sesión corta'));
  });

  test('interruptions use neutral copy before generic completed insight', () {
    final value = service.select(input(completed: 1, interruptions: 3));
    expect(value.title, 'Retoma con calma');
    expect(value.message, isNot(contains('fracaso')));
  });

  test('significant time and completed activity remain encouraging', () {
    expect(
      service.select(input(completed: 2, focusedMinutes: 50)).actionType,
      DashboardInsightAction.openAnalytics,
    );
    expect(
      service.select(input(completed: 1, focusedMinutes: 25)).title,
      'Ya avanzaste hoy',
    );
  });

  test('selection is deterministic and does not mutate input', () {
    final source = input(completed: 1, goal: PrimaryGoal.routine);
    expect(service.select(source), service.select(source));
  });

  test(
    'DashboardInsight equality includes action, tone and non-empty copy',
    () {
      const first = DashboardInsight(
        title: 'Título',
        message: 'Mensaje',
        actionType: DashboardInsightAction.none,
        tone: DashboardInsightTone.neutral,
      );
      const second = DashboardInsight(
        title: 'Título',
        message: 'Mensaje',
        actionType: DashboardInsightAction.none,
        tone: DashboardInsightTone.neutral,
      );
      expect(first, second);
      expect(first.title, isNotEmpty);
      expect(first.message, isNotEmpty);
    },
  );
}
