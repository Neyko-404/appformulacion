import 'package:focusly/features/academic_tracker/data/data_sources/course_local_data_source.dart';
import 'package:focusly/features/academic_tracker/data/models/course_local_model.dart';
import 'package:isar_community/isar.dart';

final class IsarCourseLocalDataSource implements CourseLocalDataSource {
  const IsarCourseLocalDataSource(this._isar);
  final Isar _isar;

  QueryBuilder<CourseLocalModel, CourseLocalModel, QAfterFilterCondition>
  _owner(String ownerId) =>
      _isar.courseLocalModels.filter().ownerIdEqualTo(ownerId);

  @override
  Stream<List<CourseLocalModel>> watch(String ownerId) =>
      _owner(ownerId).watch(fireImmediately: true);

  @override
  Future<List<CourseLocalModel>> getByStatus(String ownerId, String status) =>
      _owner(ownerId).statusEqualTo(status).findAll();

  @override
  Future<CourseLocalModel?> getById(String ownerId, String courseId) =>
      _owner(ownerId).courseIdEqualTo(courseId).findFirst();

  @override
  Future<bool> codeExists(
    String ownerId,
    String code, {
    String? excludingId,
  }) async {
    final matches = await _owner(ownerId).codeEqualTo(code).findAll();
    return matches.any((item) => item.courseId != excludingId);
  }

  @override
  Future<void> put(CourseLocalModel model) async {
    try {
      await _isar.writeTxn(() async {
        final existing = await getById(model.ownerId, model.courseId);
        if (existing != null) model.id = existing.id;
        await _isar.courseLocalModels.put(model);
      });
    } on Object catch (error) {
      throw CourseLocalDataSourceException('put course', error);
    }
  }

  @override
  Future<void> delete(String ownerId, String courseId) async {
    try {
      await _isar.writeTxn(() async {
        final existing = await getById(ownerId, courseId);
        if (existing != null) await _isar.courseLocalModels.delete(existing.id);
      });
    } on Object catch (error) {
      throw CourseLocalDataSourceException('delete course', error);
    }
  }
}
