import 'package:focusly/core/logging/app_logger.dart';
import 'package:focusly/features/academic_tracker/course_analytics_reader.dart';
import 'package:focusly/features/analytics/domain/failures/analytics_failure.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

final class ReadOnlyAnalyticsRepository implements AnalyticsRepository {
  const ReadOnlyAnalyticsRepository({
    required this.studyReader,
    required this.courseReader,
    this.logger = const AppLogger(),
  });

  final StudyAnalyticsReader studyReader;
  final CourseAnalyticsReader courseReader;
  final AppLogger logger;

  @override
  Future<AnalyticsSourceSnapshot> read(String ownerId) async {
    if (ownerId.trim().isEmpty) throw AnalyticsFailure.unauthenticated();
    try {
      final records = await studyReader.readAll(ownerId);
      final courses = await courseReader.readAll(ownerId);
      return AnalyticsSourceSnapshot(records: records, courses: courses);
    } on AnalyticsFailure {
      rethrow;
    } on Object catch (error, stackTrace) {
      logger.error(
        'Analytics source read failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw AnalyticsFailure.source();
    }
  }
}
