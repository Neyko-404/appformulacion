import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/academic_tracker_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course_failure.dart';
import 'package:focusly/features/academic_tracker/domain/repositories/course_repository.dart';
import 'package:focusly/features/academic_tracker/presentation/state/course_state.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';

final class CourseNotifier extends Notifier<CourseState> {
  StreamSubscription<List<Course>>? _subscription;
  int _idSequence = 0;

  @override
  CourseState build() {
    final userId = ref.watch(publicAuthSessionProvider).user?.id;
    ref.onDispose(() => unawaited(_subscription?.cancel()));
    scheduleMicrotask(() => _observe(userId));
    return const CourseState();
  }

  Future<void> _observe(String? userId) async {
    await _subscription?.cancel();
    if (userId == null) {
      state = const CourseState(
        isInitializing: false,
        errorMessage: 'Necesitas una sesión válida para gestionar cursos.',
      );
      return;
    }
    _subscription = ref
        .read(courseRepositoryProvider)
        .watch(userId)
        .listen(
          (courses) {
            if (ref.read(publicAuthSessionProvider).user?.id != userId) return;
            state = state.copyWith(
              isInitializing: false,
              activeCourses: courses
                  .where((course) => course.status == CourseStatus.active)
                  .toList(growable: false),
              archivedCourses: courses
                  .where((course) => course.status == CourseStatus.archived)
                  .toList(growable: false),
              clearFeedback: true,
            );
          },
          onError: (Object _) {
            state = state.copyWith(
              isInitializing: false,
              errorMessage: 'No pudimos cargar tus cursos.',
            );
          },
        );
  }

  void setFilter(CourseFilter filter) => state = state.copyWith(filter: filter);

  Future<bool> save({
    String? courseId,
    required String name,
    String? code,
    int? credits,
    required CourseVisualIdentity visualIdentity,
  }) async {
    if (state.isWriting) return false;
    final userId = ref.read(publicAuthSessionProvider).user?.id;
    if (userId == null) return false;
    final validator = ref.read(courseValidatorProvider);
    final error = validator.validate(
      ownerId: userId,
      name: name,
      code: code,
      credits: credits,
      visualIdentity: visualIdentity,
      status: CourseStatus.active,
    );
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return false;
    }
    state = state.copyWith(isWriting: true, clearFeedback: true);
    try {
      final repository = ref.read(courseRepositoryProvider);
      final existing = courseId == null
          ? null
          : await repository.getById(userId, courseId);
      if (courseId != null && existing == null) throw CourseFailure.notFound();
      final now = ref.read(courseClockProvider)();
      final normalizedCode = validator.normalizeCode(code ?? '');
      await repository.save(
        Course(
          id: existing?.id ?? '${now.microsecondsSinceEpoch}-${_idSequence++}',
          ownerId: userId,
          name: validator.normalize(name),
          code: normalizedCode.isEmpty ? null : normalizedCode,
          credits: credits,
          visualIdentity: visualIdentity,
          status: existing?.status ?? CourseStatus.active,
          createdAt: existing?.createdAt ?? now,
          updatedAt: now,
        ),
      );
      state = state.copyWith(
        isWriting: false,
        message: courseId == null ? 'Curso creado.' : 'Curso actualizado.',
      );
      return true;
    } on CourseFailure catch (failure) {
      state = state.copyWith(
        isWriting: false,
        errorMessage: failure.safeMessage,
      );
      return false;
    } on Object {
      state = state.copyWith(
        isWriting: false,
        errorMessage: 'No pudimos guardar el curso.',
      );
      return false;
    }
  }

  Future<void> archive(String id) => _status(id, archived: true);
  Future<void> restore(String id) => _status(id, archived: false);
  Future<void> _status(String id, {required bool archived}) => _write(
    (repo, userId, now) => archived
        ? repo.archive(userId, id, now)
        : repo.restore(userId, id, now),
  );
  Future<void> delete(String id) =>
      _write((repo, userId, _) => repo.delete(userId, id));

  Future<void> _write(
    Future<void> Function(
      CourseRepository repository,
      String userId,
      DateTime now,
    )
    action,
  ) async {
    if (state.isWriting) return;
    final userId = ref.read(publicAuthSessionProvider).user?.id;
    if (userId == null) return;
    state = state.copyWith(isWriting: true, clearFeedback: true);
    try {
      await action(
        ref.read(courseRepositoryProvider),
        userId,
        ref.read(courseClockProvider)(),
      );
      state = state.copyWith(isWriting: false);
    } on CourseFailure catch (failure) {
      state = state.copyWith(
        isWriting: false,
        errorMessage: failure.safeMessage,
      );
    }
  }
}
