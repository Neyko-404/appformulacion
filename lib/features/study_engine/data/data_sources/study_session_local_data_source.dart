import 'package:focusly/features/study_engine/data/models/study_session_local_model.dart';

abstract interface class StudySessionLocalDataSource {
  Stream<StudySessionLocalModel?> watchActive(String ownerId);
  Future<StudySessionLocalModel?> getActive(String ownerId);
  Future<void> put(StudySessionLocalModel model);
  Future<List<StudySessionLocalModel>> recent(String ownerId, int limit);
  Future<List<StudySessionLocalModel>> byCourse(
    String ownerId,
    String courseId,
  );
  Future<void> clear(String ownerId);
}
