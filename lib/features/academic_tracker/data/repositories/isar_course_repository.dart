import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/academic_tracker/data/data_sources/course_local_data_source.dart';
import 'package:focusly/features/academic_tracker/data/mappers/course_mapper.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course_failure.dart';
import 'package:focusly/features/academic_tracker/domain/repositories/course_repository.dart';

final class IsarCourseRepository implements CourseRepository {
  const IsarCourseRepository(
    this._source, {
    this.mapper = const CourseMapper(),
    this.logger = const AppLogger(),
  });
  final CourseLocalDataSource _source;
  final CourseMapper mapper;
  final AppLogger logger;

  @override
  Stream<List<Course>> watch(String ownerId) => _source
      .watch(ownerId)
      .map((models) => models.map(mapper.toDomain).toList(growable: false));

  @override
  Future<List<Course>> getByStatus(String ownerId, CourseStatus status) async {
    try {
      return (await _source.getByStatus(
        ownerId,
        status.name,
      )).map(mapper.toDomain).toList(growable: false);
    } on FormatException catch (error, stack) {
      _corrupt(error, stack);
    } on Object catch (error, stack) {
      _storage(error, stack);
    }
  }

  @override
  Future<Course?> getById(String ownerId, String courseId) async {
    try {
      final model = await _source.getById(ownerId, courseId);
      return model == null ? null : mapper.toDomain(model);
    } on FormatException catch (error, stack) {
      _corrupt(error, stack);
    } on Object catch (error, stack) {
      _storage(error, stack);
    }
  }

  @override
  Future<bool> codeExists(String ownerId, String code, {String? excludingId}) =>
      _source.codeExists(ownerId, code, excludingId: excludingId);

  @override
  Future<void> save(Course course) async {
    try {
      final code = course.code;
      if (code != null &&
          await codeExists(course.ownerId, code, excludingId: course.id)) {
        throw CourseFailure.duplicateCode();
      }
      await _source.put(mapper.toLocal(course));
    } on CourseFailure {
      rethrow;
    } on Object catch (error, stack) {
      _storage(error, stack);
    }
  }

  @override
  Future<void> archive(String ownerId, String courseId, DateTime updatedAt) =>
      _changeStatus(ownerId, courseId, CourseStatus.archived, updatedAt);
  @override
  Future<void> restore(String ownerId, String courseId, DateTime updatedAt) =>
      _changeStatus(ownerId, courseId, CourseStatus.active, updatedAt);

  Future<void> _changeStatus(
    String ownerId,
    String courseId,
    CourseStatus status,
    DateTime updatedAt,
  ) async {
    final course = await getById(ownerId, courseId);
    if (course == null) {
      throw CourseFailure.notFound();
    }
    await save(course.copyWith(status: status, updatedAt: updatedAt));
  }

  @override
  Future<void> delete(String ownerId, String courseId) async {
    if (await getById(ownerId, courseId) == null) {
      throw CourseFailure.notFound();
    }
    try {
      await _source.delete(ownerId, courseId);
    } on Object catch (error, stack) {
      _storage(error, stack);
    }
  }

  Never _storage(Object error, StackTrace stack) {
    logger.error(
      'Course storage operation failed',
      error: error,
      stackTrace: stack,
    );
    throw CourseFailure.storage();
  }

  Never _corrupt(Object error, StackTrace stack) {
    logger.error('Corrupted course data', error: error, stackTrace: stack);
    throw CourseFailure.corruptedData();
  }
}
