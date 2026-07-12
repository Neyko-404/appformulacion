import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

final class ActiveCoursesSnapshot {
  const ActiveCoursesSnapshot({
    required this.courses,
    required this.isLoading,
    this.errorMessage,
  });
  final List<Course> courses;
  final bool isLoading;
  final String? errorMessage;
  int get count => courses.length;
}

final activeCoursesProvider = Provider<ActiveCoursesSnapshot>((ref) {
  final state = ref.watch(courseNotifierProvider);
  return ActiveCoursesSnapshot(
    courses: List.unmodifiable(state.activeCourses),
    isLoading: state.isInitializing,
    errorMessage: state.errorMessage,
  );
});
