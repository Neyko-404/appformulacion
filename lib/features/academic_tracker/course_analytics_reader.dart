import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

abstract interface class CourseAnalyticsReader {
  Future<List<Course>> readAll(String ownerId);
}
