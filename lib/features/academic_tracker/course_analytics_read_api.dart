import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/course_analytics_reader.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/domain/repositories/course_repository.dart';

final courseAnalyticsReaderProvider = Provider<CourseAnalyticsReader>(
  (ref) =>
      _RepositoryCourseAnalyticsReader(ref.watch(courseRepositoryProvider)),
);

final class _RepositoryCourseAnalyticsReader implements CourseAnalyticsReader {
  const _RepositoryCourseAnalyticsReader(this.repository);

  final CourseRepository repository;

  @override
  Future<List<Course>> readAll(String ownerId) async {
    final active = await repository.getByStatus(ownerId, CourseStatus.active);
    final archived = await repository.getByStatus(
      ownerId,
      CourseStatus.archived,
    );
    return List.unmodifiable([...active, ...archived]);
  }
}
