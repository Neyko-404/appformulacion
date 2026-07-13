import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/course_analytics_reader.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/analytics/data/repositories/read_only_analytics_repository.dart';
import 'package:focusly/features/analytics/domain/failures/analytics_failure.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

void main() {
  test('combines read-only sources using the same owner id', () async {
    final study = _StudyReader();
    final courses = _CourseReader();
    final repository = ReadOnlyAnalyticsRepository(
      studyReader: study,
      courseReader: courses,
    );
    final value = await repository.read('user-1');
    expect(value.records, isEmpty);
    expect(value.courses, isEmpty);
    expect(study.ownerId, 'user-1');
    expect(courses.ownerId, 'user-1');
  });

  test('normalizes source failures and rejects empty owner', () async {
    final repository = ReadOnlyAnalyticsRepository(
      studyReader: _StudyReader(fail: true),
      courseReader: _CourseReader(),
    );
    await expectLater(
      repository.read('user-1'),
      throwsA(
        isA<AnalyticsFailure>().having(
          (value) => value.type,
          'type',
          AnalyticsFailureType.sourceFailure,
        ),
      ),
    );
    await expectLater(repository.read(''), throwsA(isA<AnalyticsFailure>()));
  });
}

final class _StudyReader implements StudyAnalyticsReader {
  _StudyReader({this.fail = false});
  final bool fail;
  String? ownerId;
  @override
  Future<List<StudyAnalyticsRecord>> readAll(String ownerId) async {
    this.ownerId = ownerId;
    if (fail) throw StateError('storage');
    return const [];
  }
}

final class _CourseReader implements CourseAnalyticsReader {
  String? ownerId;
  @override
  Future<List<Course>> readAll(String ownerId) async {
    this.ownerId = ownerId;
    return const [];
  }
}
