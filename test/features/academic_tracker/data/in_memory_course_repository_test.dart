import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/data/repositories/in_memory_course_repository.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course_failure.dart';

void main() {
  final now = DateTime.utc(2026, 7, 12);
  Course course(String id, String owner, {String? code = 'MAT-101'}) => Course(
    id: id,
    ownerId: owner,
    name: 'Matemática',
    code: code,
    credits: 4,
    visualIdentity: CourseVisualIdentity.ocean,
    status: CourseStatus.active,
    createdAt: now,
    updatedAt: now,
  );

  test('creates, observes, edits, archives, restores, and deletes', () async {
    final repository = InMemoryCourseRepository();
    addTearDown(repository.dispose);
    final emissionsFuture = repository.watch('user-1').take(2).toList();
    await repository.save(course('course-1', 'user-1'));
    final emissions = await emissionsFuture;
    expect(emissions.first, isEmpty);
    expect(emissions.last, hasLength(1));
    expect(
      (await repository.getByStatus('user-1', CourseStatus.active)),
      hasLength(1),
    );
    await repository.save(
      course('course-1', 'user-1').copyWith(name: 'Álgebra'),
    );
    expect((await repository.getById('user-1', 'course-1'))?.name, 'Álgebra');
    await repository.archive('user-1', 'course-1', now);
    expect(
      (await repository.getByStatus('user-1', CourseStatus.archived)),
      hasLength(1),
    );
    await repository.restore('user-1', 'course-1', now);
    await repository.delete('user-1', 'course-1');
    expect(await repository.getById('user-1', 'course-1'), isNull);
  });

  test('duplicate code is per owner and users are isolated', () async {
    final repository = InMemoryCourseRepository();
    addTearDown(repository.dispose);
    await repository.save(course('one', 'user-1'));
    await expectLater(
      repository.save(course('two', 'user-1')),
      throwsA(isA<CourseFailure>()),
    );
    await repository.save(course('three', 'user-2'));
    expect(await repository.getById('user-1', 'three'), isNull);
    expect(await repository.getById('user-2', 'three'), isNotNull);
  });
}
