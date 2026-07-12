import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

enum CourseFilter { active, archived }

final class CourseState {
  const CourseState({
    this.isInitializing = true,
    this.isWriting = false,
    this.activeCourses = const [],
    this.archivedCourses = const [],
    this.filter = CourseFilter.active,
    this.message,
    this.errorMessage,
  });
  final bool isInitializing;
  final bool isWriting;
  final List<Course> activeCourses;
  final List<Course> archivedCourses;
  final CourseFilter filter;
  final String? message;
  final String? errorMessage;

  List<Course> get visibleCourses =>
      filter == CourseFilter.active ? activeCourses : archivedCourses;

  CourseState copyWith({
    bool? isInitializing,
    bool? isWriting,
    List<Course>? activeCourses,
    List<Course>? archivedCourses,
    CourseFilter? filter,
    String? message,
    String? errorMessage,
    bool clearFeedback = false,
  }) => CourseState(
    isInitializing: isInitializing ?? this.isInitializing,
    isWriting: isWriting ?? this.isWriting,
    activeCourses: activeCourses ?? this.activeCourses,
    archivedCourses: archivedCourses ?? this.archivedCourses,
    filter: filter ?? this.filter,
    message: clearFeedback ? null : message ?? this.message,
    errorMessage: clearFeedback ? null : errorMessage ?? this.errorMessage,
  );
}
