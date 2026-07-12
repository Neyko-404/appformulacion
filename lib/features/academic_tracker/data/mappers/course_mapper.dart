import 'package:focusly/features/academic_tracker/data/models/course_local_model.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

final class CourseMapper {
  const CourseMapper();
  CourseLocalModel toLocal(Course course) => CourseLocalModel()
    ..courseId = course.id
    ..ownerId = course.ownerId
    ..name = course.name
    ..code = course.code
    ..credits = course.credits
    ..visualIdentity = course.visualIdentity.name
    ..status = course.status.name
    ..createdAt = course.createdAt
    ..updatedAt = course.updatedAt;

  Course toDomain(CourseLocalModel model) => Course(
    id: model.courseId,
    ownerId: model.ownerId,
    name: model.name,
    code: model.code,
    credits: model.credits,
    visualIdentity: CourseVisualIdentity.values.firstWhere(
      (value) => value.name == model.visualIdentity,
      orElse: () => throw const FormatException('Unknown visual identity'),
    ),
    status: CourseStatus.values.firstWhere(
      (value) => value.name == model.status,
      orElse: () => throw const FormatException('Unknown course status'),
    ),
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
  );
}
