import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/domain/services/course_validator.dart';

void main() {
  const validator = CourseValidator();
  final now = DateTime.utc(2026, 7, 12);
  Course course() => Course(
    id: 'course-1',
    ownerId: 'user-1',
    name: 'Matemática',
    code: 'MAT-101',
    credits: 4,
    visualIdentity: CourseVisualIdentity.ocean,
    status: CourseStatus.active,
    createdAt: now,
    updatedAt: now,
  );

  test('creates, compares, and copies an immutable course', () {
    expect(course(), course());
    final later = now.add(const Duration(days: 1));
    final edited = course().copyWith(
      name: 'Matemática II',
      status: CourseStatus.archived,
      updatedAt: later,
    );
    expect(edited.createdAt, now);
    expect(edited.updatedAt, later);
    expect(edited.status, CourseStatus.archived);
  });

  test('normalizes name and code spaces', () {
    expect(validator.normalize('  Matemática   I '), 'Matemática I');
    expect(validator.normalizeCode('  mat  101 '), 'MAT 101');
  });

  test('validates owner, name, code, credits, identity, and status', () {
    expect(validator.ownerId(''), isNotNull);
    expect(validator.name(''), isNotNull);
    expect(validator.name('A'), isNotNull);
    expect(validator.name(List.filled(81, 'a').join()), isNotNull);
    expect(validator.code(List.filled(21, 'x').join()), isNotNull);
    expect(validator.credits(-1), isNotNull);
    expect(validator.credits(31), isNotNull);
    expect(
      validator.validate(
        ownerId: 'user-1',
        name: 'Matemática',
        code: 'MAT-101',
        credits: 4,
        visualIdentity: CourseVisualIdentity.forest,
        status: CourseStatus.active,
      ),
      isNull,
    );
  });
}
