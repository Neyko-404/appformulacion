import 'package:isar_community/isar.dart';

part 'study_session_local_model.g.dart';

@collection
class StudySessionLocalModel {
  Id id = Isar.autoIncrement;
  @Index()
  late String sessionId;
  @Index()
  late String ownerId;
  @Index()
  String? courseId;
  late String mode;
  @Index()
  late String status;
  late int plannedDurationSeconds;
  late int accumulatedFocusSeconds;
  DateTime? startedAt;
  DateTime? plannedEndAt;
  DateTime? pausedAt;
  DateTime? completedAt;
  DateTime? cancelledAt;
  late DateTime createdAt;
  late DateTime updatedAt;
}
