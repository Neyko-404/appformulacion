import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

enum CompanionMessagePhase {
  ready,
  start,
  middle,
  finalStretch,
  lastEffort,
  paused,
  completed,
  cancelled,
}

final class CompanionMessageService {
  const CompanionMessageService();

  CompanionMessagePhase phase({
    required StudySessionStatus status,
    required Duration remaining,
    required Duration plannedDuration,
  }) {
    switch (status) {
      case StudySessionStatus.ready:
        return CompanionMessagePhase.ready;
      case StudySessionStatus.paused:
        return CompanionMessagePhase.paused;
      case StudySessionStatus.completed:
        return CompanionMessagePhase.completed;
      case StudySessionStatus.cancelled:
        return CompanionMessagePhase.cancelled;
      case StudySessionStatus.running:
        if (plannedDuration <= Duration.zero) {
          return CompanionMessagePhase.start;
        }
        final remainingRatio =
            (remaining.inMilliseconds / plannedDuration.inMilliseconds).clamp(
              0.0,
              1.0,
            );
        if (remainingRatio <= 0.05) return CompanionMessagePhase.lastEffort;
        if (remainingRatio <= 0.20) return CompanionMessagePhase.finalStretch;
        if (remainingRatio <= 0.50) return CompanionMessagePhase.middle;
        return CompanionMessagePhase.start;
    }
  }

  String message({
    required StudySessionStatus status,
    required Duration remaining,
    required Duration plannedDuration,
  }) => switch (phase(
    status: status,
    remaining: remaining,
    plannedDuration: plannedDuration,
  )) {
    CompanionMessagePhase.ready => 'Todo listo. Comienza cuando quieras.',
    CompanionMessagePhase.start => 'Ya comenzaste.',
    CompanionMessagePhase.middle => 'Buen ritmo.',
    CompanionMessagePhase.finalStretch => 'Ya casi terminas.',
    CompanionMessagePhase.lastEffort => 'Último esfuerzo.',
    CompanionMessagePhase.paused =>
      'Tómate un momento. Continúa cuando estés listo.',
    CompanionMessagePhase.completed => 'Buen trabajo. Ahora descansa un poco.',
    CompanionMessagePhase.cancelled =>
      'No pasa nada. Puedes intentarlo nuevamente.',
  };
}
