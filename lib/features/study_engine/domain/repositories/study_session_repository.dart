import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

abstract interface class StudySessionRepository {
  Stream<StudySession?> watchActive(String ownerId);
  Future<StudySession?> getActive(String ownerId);
  Future<void> save(StudySession session);
  Future<List<StudySession>> recent(String ownerId, {int limit = 30});
  Future<List<StudySession>> byCourse(String ownerId, String courseId);
  Future<void> clearForTests(String ownerId);
}
