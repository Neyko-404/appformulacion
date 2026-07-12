import 'package:isar_community/isar.dart';

part 'study_companion_local_model.g.dart';

@collection
class StudyCompanionLocalModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String companionId;

  @Index()
  late String ownerId;

  late String name;
  late String appearance;
  late DateTime createdAt;
}
