import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/data/mappers/course_mapper.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';

void main() {
  const mapper = CourseMapper();
  final now = DateTime.utc(2026, 7, 12);
  final course = Course(
    id: 'domain-id',
    ownerId: 'user-1',
    name: 'Matemática',
    code: 'MAT-101',
    credits: 4,
    visualIdentity: CourseVisualIdentity.violet,
    status: CourseStatus.active,
    createdAt: now,
    updatedAt: now,
  );

  test('round trip preserves fields and domain identity', () {
    final local = mapper.toLocal(course)..id = 42;
    expect(mapper.toDomain(local), course);
    expect(local.courseId, 'domain-id');
    expect(local.visualIdentity, 'violet');
  });

  test('unknown visual identity and status are rejected', () {
    final local = mapper.toLocal(course)..visualIdentity = 'unknown';
    expect(() => mapper.toDomain(local), throwsFormatException);
    local
      ..visualIdentity = 'ocean'
      ..status = 'unknown';
    expect(() => mapper.toDomain(local), throwsFormatException);
  });
}
