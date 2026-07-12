import 'package:focusly/features/study_engine/data/data_sources/study_session_local_data_source.dart';
import 'package:focusly/features/study_engine/data/models/study_session_local_model.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:isar_community/isar.dart';

final class IsarStudySessionLocalDataSource
    implements StudySessionLocalDataSource {
  const IsarStudySessionLocalDataSource(this._isar);
  final Isar _isar;
  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  _owner(String ownerId) =>
      _isar.studySessionLocalModels.filter().ownerIdEqualTo(ownerId);

  QueryBuilder<
    StudySessionLocalModel,
    StudySessionLocalModel,
    QAfterFilterCondition
  >
  _active(String ownerId) => _owner(ownerId).group(
    (query) => query
        .statusEqualTo(StudySessionStatus.running.name)
        .or()
        .statusEqualTo(StudySessionStatus.paused.name),
  );

  @override
  Stream<StudySessionLocalModel?> watchActive(String ownerId) => _active(
    ownerId,
  ).watch(fireImmediately: true).map((items) => items.firstOrNull);
  @override
  Future<StudySessionLocalModel?> getActive(String ownerId) =>
      _active(ownerId).findFirst();
  @override
  Future<void> put(StudySessionLocalModel model) => _isar.writeTxn(() async {
    final existing = await _owner(
      model.ownerId,
    ).sessionIdEqualTo(model.sessionId).findFirst();
    if (existing != null) model.id = existing.id;
    await _isar.studySessionLocalModels.put(model);
  });
  @override
  Future<List<StudySessionLocalModel>> recent(String ownerId, int limit) =>
      _owner(ownerId).sortByUpdatedAtDesc().limit(limit).findAll();
  @override
  Future<List<StudySessionLocalModel>> byCourse(
    String ownerId,
    String courseId,
  ) => _owner(ownerId).courseIdEqualTo(courseId).findAll();
  @override
  Future<void> clear(String ownerId) => _isar.writeTxn(() async {
    final ids = await _owner(ownerId).idProperty().findAll();
    await _isar.studySessionLocalModels.deleteAll(ids);
  });
}
