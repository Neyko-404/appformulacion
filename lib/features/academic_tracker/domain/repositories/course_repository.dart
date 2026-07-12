import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

abstract interface class CourseRepository {
  Stream<List<Course>> watch(String ownerId);
  Future<List<Course>> getByStatus(String ownerId, CourseStatus status);
  Future<Course?> getById(String ownerId, String courseId);
  Future<bool> codeExists(String ownerId, String code, {String? excludingId});
  Future<void> save(Course course);
  Future<void> archive(String ownerId, String courseId, DateTime updatedAt);
  Future<void> restore(String ownerId, String courseId, DateTime updatedAt);
  Future<void> delete(String ownerId, String courseId);
}
