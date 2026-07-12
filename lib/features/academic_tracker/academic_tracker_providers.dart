import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/data/data_sources/course_local_data_source.dart';
import 'package:focusly/features/academic_tracker/data/data_sources/isar_course_local_data_source.dart';
import 'package:focusly/features/academic_tracker/data/repositories/in_memory_course_repository.dart';
import 'package:focusly/features/academic_tracker/data/repositories/isar_course_repository.dart';
import 'package:focusly/features/academic_tracker/domain/repositories/course_repository.dart';
import 'package:focusly/features/academic_tracker/domain/services/course_validator.dart';
import 'package:focusly/features/academic_tracker/presentation/notifiers/course_notifier.dart';
import 'package:focusly/features/academic_tracker/presentation/state/course_state.dart';
import 'package:focusly/services/local_database/local_database_provider.dart';

final courseLocalDataSourceProvider = Provider<CourseLocalDataSource>((ref) {
  final database = ref.watch(localDatabaseProvider);
  if (database == null) throw StateError('Local database is unavailable.');
  return IsarCourseLocalDataSource(database);
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  if (ref.watch(localDatabaseProvider) == null) {
    return InMemoryCourseRepository();
  }
  return IsarCourseRepository(ref.watch(courseLocalDataSourceProvider));
});

final courseValidatorProvider = Provider<CourseValidator>(
  (ref) => const CourseValidator(),
);
final courseClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);
final courseNotifierProvider = NotifierProvider<CourseNotifier, CourseState>(
  CourseNotifier.new,
);
