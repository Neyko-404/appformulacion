import 'package:isar_community/isar.dart';

part 'focus_goal_local_model.g.dart';

@collection
class FocusGoalLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ownerId;

  int? dailyMinutesTarget;
  int? weeklyCompletedSessionsTarget;
  int? weeklyActiveDaysTarget;
  late DateTime createdAt;
  late DateTime updatedAt;
}
