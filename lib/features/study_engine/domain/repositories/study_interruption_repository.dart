import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';

abstract interface class StudyInterruptionRepository {
  Future<void> saveOpen(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  );
  Future<void> saveClosed(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  );
  Future<void> discard(String ownerId, String interruptionId);
  Future<StudyInterruption?> open(String ownerId, String sessionId);
  Future<List<StudyInterruption>> bySession(String ownerId, String sessionId);
  Future<int> count(String ownerId, String sessionId);
  Future<void> clearForTests(String ownerId);
}
