import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/data/repositories/in_memory_course_repository.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';

void main() {
  const session = AuthSession.authenticated(
    user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
    emailVerified: true,
  );

  test('creates, edits, archives, restores, and deletes courses', () async {
    final repository = InMemoryCourseRepository();
    addTearDown(repository.dispose);
    final container = ProviderContainer.test(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(session),
        courseRepositoryProvider.overrideWithValue(repository),
        courseClockProvider.overrideWithValue(() => DateTime.utc(2026, 7, 12)),
      ],
    );
    addTearDown(container.dispose);
    final ready = Completer<void>();
    final subscription = container.listen(courseNotifierProvider, (_, next) {
      if (!next.isInitializing && !ready.isCompleted) ready.complete();
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;
    final notifier = container.read(courseNotifierProvider.notifier);

    expect(
      await notifier.save(
        name: '  Matemática  ',
        code: ' MAT-101 ',
        credits: 4,
        visualIdentity: CourseVisualIdentity.ocean,
      ),
      isTrue,
    );
    final created = (await repository.getByStatus(
      'user-1',
      CourseStatus.active,
    )).single;
    expect(created.name, 'Matemática');
    expect(created.code, 'MAT-101');

    await notifier.save(
      courseId: created.id,
      name: 'Álgebra',
      code: created.code,
      credits: 5,
      visualIdentity: CourseVisualIdentity.forest,
    );
    expect((await repository.getById('user-1', created.id))?.name, 'Álgebra');
    await notifier.archive(created.id);
    expect(
      await repository.getByStatus('user-1', CourseStatus.archived),
      hasLength(1),
    );
    await notifier.restore(created.id);
    await notifier.archive(created.id);
    await notifier.delete(created.id);
    expect(await repository.getById('user-1', created.id), isNull);
  });

  test('session without user exposes a safe error', () async {
    final container = ProviderContainer.test(
      overrides: [
        publicAuthSessionProvider.overrideWithValue(
          const AuthSession.unauthenticated(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final ready = Completer<void>();
    final subscription = container.listen(courseNotifierProvider, (_, next) {
      if (!next.isInitializing && !ready.isCompleted) ready.complete();
    }, fireImmediately: true);
    addTearDown(subscription.close);
    await ready.future;
    expect(container.read(courseNotifierProvider).errorMessage, isNotNull);
  });
}
