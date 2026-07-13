import 'package:focusly/features/study_engine/data/data_sources/study_interruption_local_data_source.dart';
import 'package:focusly/features/study_engine/data/models/study_interruption_local_model.dart';
import 'package:isar_community/isar.dart';

final class IsarStudyInterruptionLocalDataSource
    implements StudyInterruptionLocalDataSource {
  const IsarStudyInterruptionLocalDataSource(this._isar);
  final Isar _isar;

  @override
  Future<void> put(StudyInterruptionLocalModel model) =>
      _isar.writeTxn(() async {
        final existing = await _isar.studyInterruptionLocalModels
            .filter()
            .ownerIdEqualTo(model.ownerId)
            .interruptionIdEqualTo(model.interruptionId)
            .findFirst();
        if (existing != null) model.id = existing.id;
        await _isar.studyInterruptionLocalModels.put(model);
      });

  @override
  Future<void> delete(String ownerId, String interruptionId) =>
      _isar.writeTxn(() async {
        final value = await _isar.studyInterruptionLocalModels
            .filter()
            .ownerIdEqualTo(ownerId)
            .interruptionIdEqualTo(interruptionId)
            .findFirst();
        if (value != null) {
          await _isar.studyInterruptionLocalModels.delete(value.id);
        }
      });

  @override
  Future<StudyInterruptionLocalModel?> open(String ownerId, String sessionId) =>
      _isar.studyInterruptionLocalModels
          .filter()
          .ownerIdEqualTo(ownerId)
          .sessionIdEqualTo(sessionId)
          .endedAtIsNull()
          .findFirst();

  @override
  Future<List<StudyInterruptionLocalModel>> bySession(
    String ownerId,
    String sessionId,
  ) => _isar.studyInterruptionLocalModels
      .filter()
      .ownerIdEqualTo(ownerId)
      .sessionIdEqualTo(sessionId)
      .endedAtIsNotNull()
      .sortByStartedAt()
      .findAll();

  @override
  Future<void> clear(String ownerId) => _isar.writeTxn(() async {
    final ids = await _isar.studyInterruptionLocalModels
        .filter()
        .ownerIdEqualTo(ownerId)
        .idProperty()
        .findAll();
    await _isar.studyInterruptionLocalModels.deleteAll(ids);
  });
}
