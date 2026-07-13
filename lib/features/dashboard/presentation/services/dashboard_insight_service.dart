import 'package:focusly/features/dashboard/presentation/models/dashboard_insight.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

final class DashboardInsightInput {
  const DashboardInsightInput({
    required this.focusedDurationToday,
    required this.completedSessionsToday,
    required this.interruptionCountToday,
    required this.preferredFocusMinutes,
    required this.primaryGoal,
    required this.hasCourses,
    required this.analyticsAvailable,
    required this.coursesAvailable,
    this.activeSessionStatus,
  });

  final Duration focusedDurationToday;
  final int completedSessionsToday;
  final StudySessionStatus? activeSessionStatus;
  final int interruptionCountToday;
  final int preferredFocusMinutes;
  final PrimaryGoal primaryGoal;
  final bool hasCourses;
  final bool analyticsAvailable;
  final bool coursesAvailable;
}

final class DashboardInsightService {
  const DashboardInsightService();

  DashboardInsight select(DashboardInsightInput input) {
    if (input.activeSessionStatus == StudySessionStatus.running) {
      return const DashboardInsight(
        title: 'Tu sesión sigue en curso',
        message:
            'Puedes volver cuando quieras y continuar desde donde estabas.',
        actionType: DashboardInsightAction.continueFocus,
        tone: DashboardInsightTone.informative,
      );
    }
    if (input.activeSessionStatus == StudySessionStatus.paused) {
      return const DashboardInsight(
        title: 'Tu sesión está en pausa',
        message: 'Retómala cuando estés listo.',
        actionType: DashboardInsightAction.continueFocus,
        tone: DashboardInsightTone.neutral,
      );
    }
    if (!input.analyticsAvailable || !input.coursesAvailable) {
      return const DashboardInsight(
        title: 'Preparando tu resumen',
        message: 'Tus datos del día estarán disponibles en un momento.',
        actionType: DashboardInsightAction.none,
        tone: DashboardInsightTone.neutral,
      );
    }
    if (!input.hasCourses) {
      return const DashboardInsight(
        title: 'Organiza tu próximo paso',
        message: 'Agrega tu primer curso para organizar mejor tus sesiones.',
        actionType: DashboardInsightAction.openCourses,
        tone: DashboardInsightTone.informative,
      );
    }
    if (input.completedSessionsToday == 0) {
      final message = input.primaryGoal == PrimaryGoal.routine
          ? 'Una sesión breve puede ayudarte a dar continuidad a tu rutina.'
          : 'Puedes comenzar con una sesión corta.';
      return DashboardInsight(
        title: 'Un paso a la vez',
        message: message,
        actionType: DashboardInsightAction.startFocus,
        tone: DashboardInsightTone.encouraging,
      );
    }
    if (input.interruptionCountToday >= 3 &&
        input.interruptionCountToday >= input.completedSessionsToday * 2) {
      return const DashboardInsight(
        title: 'Retoma con calma',
        message:
            'Hoy hubo varias pausas fuera de Focusly. Una sesión breve puede ayudarte a retomar.',
        actionType: DashboardInsightAction.startFocus,
        tone: DashboardInsightTone.neutral,
      );
    }
    if (input.focusedDurationToday.inMinutes >=
        input.preferredFocusMinutes * 2) {
      return const DashboardInsight(
        title: 'Buen bloque de estudio',
        message: 'Has dedicado un buen bloque de tiempo hoy.',
        actionType: DashboardInsightAction.openAnalytics,
        tone: DashboardInsightTone.encouraging,
      );
    }
    return const DashboardInsight(
      title: 'Ya avanzaste hoy',
      message: 'Puedes continuar cuando estés listo.',
      actionType: DashboardInsightAction.startFocus,
      tone: DashboardInsightTone.encouraging,
    );
  }
}
