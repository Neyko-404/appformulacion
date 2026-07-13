import 'package:focusly/features/study_engine/data/models/study_interruption_local_model.dart';
import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';

final class StudyInterruptionMapper {
  const StudyInterruptionMapper();

  StudyInterruptionLocalModel toLocal(
    String ownerId,
    String sessionId,
    StudyInterruption value,
  ) => StudyInterruptionLocalModel()
    ..interruptionId = value.id
    ..ownerId = ownerId
    ..sessionId = sessionId
    ..startedAt = value.startedAt
    ..endedAt = value.endedAt
    ..durationSeconds = value.duration.inSeconds
    ..reason = value.reason.name
    ..createdAt = value.createdAt;

  StudyInterruption toDomain(StudyInterruptionLocalModel model) {
    if (model.interruptionId.trim().isEmpty ||
        model.ownerId.trim().isEmpty ||
        model.sessionId.trim().isEmpty ||
        model.durationSeconds < 0) {
      throw const FormatException('Invalid interruption data');
    }
    final reason = StudyInterruptionReason.values.firstWhere(
      (value) => value.name == model.reason,
      orElse: () => throw const FormatException('Unknown interruption reason'),
    );
    final interruption = StudyInterruption(
      id: model.interruptionId,
      startedAt: model.startedAt,
      endedAt: model.endedAt,
      reason: reason,
      createdAt: model.createdAt,
    );
    if (model.endedAt == null && model.durationSeconds != 0 ||
        model.endedAt != null &&
            model.durationSeconds != interruption.duration.inSeconds) {
      throw const FormatException('Incoherent interruption duration');
    }
    return interruption;
  }
}
