import 'package:focusly/features/study_engine/data/models/study_session_local_model.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

final class StudySessionMapper {
  const StudySessionMapper();
  StudySessionLocalModel toLocal(StudySession value) => StudySessionLocalModel()
    ..sessionId = value.id
    ..ownerId = value.ownerId
    ..courseId = value.courseId
    ..mode = value.mode.name
    ..status = value.status.name
    ..plannedDurationSeconds = value.plannedDuration.inSeconds
    ..accumulatedFocusSeconds = value.accumulatedFocusDuration.inSeconds
    ..startedAt = value.startedAt
    ..plannedEndAt = value.plannedEndAt
    ..pausedAt = value.pausedAt
    ..completedAt = value.completedAt
    ..cancelledAt = value.cancelledAt
    ..createdAt = value.createdAt
    ..updatedAt = value.updatedAt;

  StudySession toDomain(StudySessionLocalModel model) {
    if (model.sessionId.trim().isEmpty ||
        model.ownerId.trim().isEmpty ||
        model.plannedDurationSeconds <= 0 ||
        model.accumulatedFocusSeconds < 0 ||
        model.accumulatedFocusSeconds > model.plannedDurationSeconds) {
      throw const FormatException('Invalid persisted duration');
    }
    final mode = StudyMode.values.firstWhere(
      (value) => value.name == model.mode,
      orElse: () => throw const FormatException('Unknown study mode'),
    );
    final status = StudySessionStatus.values.firstWhere(
      (value) => value.name == model.status,
      orElse: () => throw const FormatException('Unknown session status'),
    );
    final invalidRunning =
        status == StudySessionStatus.running && model.plannedEndAt == null;
    final invalidPaused =
        status == StudySessionStatus.paused &&
        (model.pausedAt == null || model.plannedEndAt != null);
    final invalidCompleted =
        status == StudySessionStatus.completed &&
        (model.completedAt == null ||
            model.cancelledAt != null ||
            model.plannedEndAt != null ||
            model.pausedAt != null);
    final invalidCancelled =
        status == StudySessionStatus.cancelled &&
        (model.cancelledAt == null ||
            model.completedAt != null ||
            model.plannedEndAt != null ||
            model.pausedAt != null);
    if (invalidRunning ||
        invalidPaused ||
        invalidCompleted ||
        invalidCancelled) {
      throw const FormatException('Incoherent persisted timestamps');
    }
    return StudySession(
      id: model.sessionId,
      ownerId: model.ownerId,
      courseId: model.courseId,
      mode: mode,
      status: status,
      plannedDuration: Duration(seconds: model.plannedDurationSeconds),
      accumulatedFocusDuration: Duration(
        seconds: model.accumulatedFocusSeconds,
      ),
      startedAt: model.startedAt,
      plannedEndAt: model.plannedEndAt,
      pausedAt: model.pausedAt,
      completedAt: model.completedAt,
      cancelledAt: model.cancelledAt,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
