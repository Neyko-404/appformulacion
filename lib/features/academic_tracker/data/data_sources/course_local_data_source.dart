import 'package:focusly/features/academic_tracker/data/models/course_local_model.dart';

abstract interface class CourseLocalDataSource {
  Stream<List<CourseLocalModel>> watch(String ownerId);
  Future<List<CourseLocalModel>> getByStatus(String ownerId, String status);
  Future<CourseLocalModel?> getById(String ownerId, String courseId);
  Future<bool> codeExists(String ownerId, String code, {String? excludingId});
  Future<void> put(CourseLocalModel model);
  Future<void> delete(String ownerId, String courseId);
}

final class CourseLocalDataSourceException implements Exception {
  const CourseLocalDataSourceException(this.operation, [this.cause]);
  final String operation;
  final Object? cause;
}
