import 'package:isar_community/isar.dart';

part 'course_local_model.g.dart';

@collection
class CourseLocalModel {
  Id id = Isar.autoIncrement;
  @Index()
  late String courseId;
  @Index()
  late String ownerId;
  late String name;
  @Index()
  String? code;
  int? credits;
  late String visualIdentity;
  @Index()
  late String status;
  late DateTime createdAt;
  late DateTime updatedAt;
}
