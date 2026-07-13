import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

final class AnalyticsSourceSnapshot {
  const AnalyticsSourceSnapshot({required this.records, required this.courses});

  final List<StudyAnalyticsRecord> records;
  final List<Course> courses;
}

abstract interface class AnalyticsRepository {
  Future<AnalyticsSourceSnapshot> read(String ownerId);
}
