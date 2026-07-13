import 'package:isar_community/isar.dart';

part 'study_interruption_local_model.g.dart';

@collection
class StudyInterruptionLocalModel {
  Id id = Isar.autoIncrement;
  @Index()
  late String interruptionId;
  @Index()
  late String ownerId;
  @Index()
  late String sessionId;
  late DateTime startedAt;
  DateTime? endedAt;
  late int durationSeconds;
  late String reason;
  late DateTime createdAt;
}
