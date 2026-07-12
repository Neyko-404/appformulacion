import 'package:isar_community/isar.dart';

part 'student_profile_local_model.g.dart';

@collection
class StudentProfileLocalModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;

  late String university;
  late String career;
  late int currentCycle;
  late String primaryGoal;
  late int preferredFocusMinutes;
  late DateTime createdAt;
  late DateTime updatedAt;
}
