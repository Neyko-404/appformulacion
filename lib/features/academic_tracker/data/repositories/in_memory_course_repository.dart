import 'dart:async';

import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course_failure.dart';
import 'package:focusly/features/academic_tracker/domain/repositories/course_repository.dart';

final class InMemoryCourseRepository implements CourseRepository {
  InMemoryCourseRepository({Iterable<Course> seed = const []}) {
    for (final course in seed) {
      _courses[course.id] = course;
    }
  }
  final Map<String, Course> _courses = {};
  final StreamController<void> _changes = StreamController.broadcast(
    sync: true,
  );

  List<Course> _owned(String ownerId) => _courses.values
      .where((course) => course.ownerId == ownerId)
      .toList(growable: false);

  @override
  Stream<List<Course>> watch(String ownerId) {
    return Stream.multi((controller) {
      final subscription = _changes.stream.listen(
        (_) => controller.add(_owned(ownerId)),
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onCancel = subscription.cancel
        ..add(_owned(ownerId));
    });
  }

  @override
  Future<List<Course>> getByStatus(String ownerId, CourseStatus status) async =>
      _owned(ownerId).where((course) => course.status == status).toList();

  @override
  Future<Course?> getById(String ownerId, String courseId) async {
    final course = _courses[courseId];
    return course?.ownerId == ownerId ? course : null;
  }

  @override
  Future<bool> codeExists(
    String ownerId,
    String code, {
    String? excludingId,
  }) async => _owned(
    ownerId,
  ).any((course) => course.id != excludingId && course.code == code);

  @override
  Future<void> save(Course course) async {
    if (course.code != null &&
        await codeExists(
          course.ownerId,
          course.code!,
          excludingId: course.id,
        )) {
      throw CourseFailure.duplicateCode();
    }
    _courses[course.id] = course;
    _changes.add(null);
  }

  @override
  Future<void> archive(String ownerId, String courseId, DateTime updatedAt) =>
      _status(ownerId, courseId, CourseStatus.archived, updatedAt);
  @override
  Future<void> restore(String ownerId, String courseId, DateTime updatedAt) =>
      _status(ownerId, courseId, CourseStatus.active, updatedAt);
  Future<void> _status(
    String ownerId,
    String id,
    CourseStatus status,
    DateTime at,
  ) async {
    final course = await getById(ownerId, id);
    if (course == null) {
      throw CourseFailure.notFound();
    }
    await save(course.copyWith(status: status, updatedAt: at));
  }

  @override
  Future<void> delete(String ownerId, String courseId) async {
    if (await getById(ownerId, courseId) == null) {
      throw CourseFailure.notFound();
    }
    _courses.remove(courseId);
    _changes.add(null);
  }

  void dispose() => unawaited(_changes.close());
}
