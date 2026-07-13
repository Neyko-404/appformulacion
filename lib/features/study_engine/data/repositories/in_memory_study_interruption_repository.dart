import 'package:focusly/features/study_engine/domain/entities/study_interruption.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/repositories/study_interruption_repository.dart';

final class InMemoryStudyInterruptionRepository
    implements StudyInterruptionRepository {
  final Map<
    String,
    ({String ownerId, String sessionId, StudyInterruption value})
  >
  _values = {};

  @override
  Future<void> saveOpen(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  ) async {
    _validate(ownerId, sessionId, interruption);
    final existing = await open(ownerId, sessionId);
    if (existing != null && existing.id != interruption.id) {
      throw const StudySessionFailure(
        StudySessionFailureType.invalidData,
        'Ya existe una interrupción abierta.',
      );
    }
    _values[interruption.id] = (
      ownerId: ownerId,
      sessionId: sessionId,
      value: interruption,
    );
  }

  @override
  Future<void> saveClosed(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  ) async {
    _validate(ownerId, sessionId, interruption);
    if (interruption.isOpen) throw StudySessionFailure.corrupted();
    _values[interruption.id] = (
      ownerId: ownerId,
      sessionId: sessionId,
      value: interruption,
    );
  }

  void _validate(
    String ownerId,
    String sessionId,
    StudyInterruption interruption,
  ) {
    if (ownerId.trim().isEmpty || sessionId.trim().isEmpty) {
      throw StudySessionFailure.corrupted();
    }
    final existing = _values[interruption.id];
    if (existing != null &&
        (existing.ownerId != ownerId || existing.sessionId != sessionId)) {
      throw StudySessionFailure.corrupted();
    }
  }

  @override
  Future<void> discard(String ownerId, String interruptionId) async {
    final existing = _values[interruptionId];
    if (existing?.ownerId == ownerId) _values.remove(interruptionId);
  }

  @override
  Future<StudyInterruption?> open(String ownerId, String sessionId) async =>
      _values.values
          .where(
            (item) =>
                item.ownerId == ownerId &&
                item.sessionId == sessionId &&
                item.value.isOpen,
          )
          .map((item) => item.value)
          .firstOrNull;

  @override
  Future<List<StudyInterruption>> bySession(
    String ownerId,
    String sessionId,
  ) async => _values.values
      .where(
        (item) =>
            item.ownerId == ownerId &&
            item.sessionId == sessionId &&
            !item.value.isOpen,
      )
      .map((item) => item.value)
      .toList();

  @override
  Future<int> count(String ownerId, String sessionId) async =>
      (await bySession(ownerId, sessionId)).length;

  @override
  Future<void> clearForTests(String ownerId) async =>
      _values.removeWhere((_, item) => item.ownerId == ownerId);
}
