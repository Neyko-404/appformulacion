import 'package:focusly/features/study_engine/data/models/study_interruption_local_model.dart';

abstract interface class StudyInterruptionLocalDataSource {
  Future<void> put(StudyInterruptionLocalModel model);
  Future<void> delete(String ownerId, String interruptionId);
  Future<StudyInterruptionLocalModel?> open(String ownerId, String sessionId);
  Future<List<StudyInterruptionLocalModel>> bySession(
    String ownerId,
    String sessionId,
  );
  Future<void> clear(String ownerId);
}
