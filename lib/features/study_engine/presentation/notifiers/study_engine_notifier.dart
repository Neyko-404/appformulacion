import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/failures/study_session_failure.dart';
import 'package:focusly/features/study_engine/domain/services/study_session_engine.dart';
import 'package:focusly/features/study_engine/presentation/state/study_engine_state.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';

final class StudyEngineNotifier extends Notifier<StudyEngineState> {
  Timer? _ticker;
  StreamSubscription<StudySession?>? _subscription;
  int _sequence = 0;
  bool _isReconciling = false;

  @override
  StudyEngineState build() {
    final userId = ref.watch(publicAuthSessionProvider).user?.id;
    ref.listen(activeCoursesProvider, (_, next) {
      final selected = state.selectedCourseId;
      if (selected != null &&
          !next.courses.any(
            (course) => course.id == selected && course.ownerId == userId,
          )) {
        state = state.copyWith(
          clearCourse: true,
          errorMessage: 'El curso seleccionado ya no está disponible.',
        );
      }
    });
    ref.onDispose(() {
      _ticker?.cancel();
      unawaited(_subscription?.cancel());
    });
    scheduleMicrotask(() => _initialize(userId));
    return const StudyEngineState();
  }

  Future<void> _initialize(String? userId) async {
    await _subscription?.cancel();
    if (userId == null) {
      state = const StudyEngineState(
        isInitializing: false,
        errorMessage: 'Necesitas una sesión válida.',
      );
      return;
    }
    final repository = ref.read(studySessionRepositoryProvider);
    try {
      final profile = await ref
          .read(onboardingRepositoryProvider)
          .getProfile(userId);
      final preferred = profile?.preferredFocusMinutes;
      final duration = {15, 25, 40, 50}.contains(preferred)
          ? Duration(minutes: preferred!)
          : const Duration(minutes: 25);
      final recent = await repository.recent(userId);
      state = state.copyWith(
        isInitializing: false,
        selectedDuration: duration,
        recentSessions: recent,
        clearFeedback: true,
      );
      _subscription = repository
          .watchActive(userId)
          .listen(
            (session) => _acceptActive(session),
            onError: (_) => state = state.copyWith(
              isInitializing: false,
              errorMessage: 'No pudimos restaurar la sesión.',
            ),
          );
    } on Object {
      state = state.copyWith(
        isInitializing: false,
        errorMessage: 'No pudimos preparar el modo enfoque.',
      );
    }
  }

  void selectDuration(Duration value) {
    if (state.activeSession == null &&
        const [15, 25, 40, 50].contains(value.inMinutes)) {
      state = state.copyWith(selectedDuration: value);
    }
  }

  void selectCourse(String? courseId) => state = courseId == null
      ? state.copyWith(clearCourse: true)
      : state.copyWith(selectedCourseId: courseId);

  void clearFinishedResult() =>
      state = state.copyWith(clearLastFinished: true, clearFeedback: true);

  Future<void> refreshHistory() async {
    final ownerId = ref.read(publicAuthSessionProvider).user?.id;
    if (ownerId == null || state.isOperating) return;
    state = state.copyWith(isOperating: true, clearFeedback: true);
    try {
      final history = await ref
          .read(studySessionRepositoryProvider)
          .recent(ownerId);
      state = state.copyWith(isOperating: false, recentSessions: history);
    } on Object {
      state = state.copyWith(
        isOperating: false,
        errorMessage: 'No pudimos actualizar el historial.',
      );
    }
  }

  Future<void> start() async {
    if (state.isOperating || state.activeSession != null) return;
    final ownerId = ref.read(publicAuthSessionProvider).user?.id;
    if (ownerId == null) return;
    final selectedCourseId = state.selectedCourseId;
    if (selectedCourseId != null) {
      final isValid = ref
          .read(activeCoursesProvider)
          .courses
          .any(
            (course) =>
                course.id == selectedCourseId && course.ownerId == ownerId,
          );
      if (!isValid) {
        state = state.copyWith(
          clearCourse: true,
          errorMessage: 'El curso seleccionado ya no está disponible.',
        );
        return;
      }
    }
    await _operate(() async {
      final clock = ref.read(studyClockProvider);
      final engine = ref.read(studySessionEngineProvider);
      final ready = engine.create(
        id: '${clock.now().microsecondsSinceEpoch}-${_sequence++}',
        ownerId: ownerId,
        courseId: selectedCourseId,
        duration: state.selectedDuration,
      );
      final running = engine.start(ready);
      state = state.copyWith(clearLastFinished: true);
      await ref.read(studySessionRepositoryProvider).save(running);
      state = state.copyWith(activeSession: running);
      _refreshRemaining();
    });
  }

  Future<void> pause() =>
      _transition((engine, session) => engine.pause(session));
  Future<void> resume() =>
      _transition((engine, session) => engine.resume(session));
  Future<void> complete() =>
      _transition((engine, session) => engine.complete(session));
  Future<void> cancel() =>
      _transition((engine, session) => engine.cancel(session));

  Future<void> reconcile() async {
    if (_isReconciling) return;
    final session = state.activeSession;
    if (session == null) return;
    _isReconciling = true;
    try {
      final reconciled = ref
          .read(studySessionEngineProvider)
          .reconcile(session);
      if (reconciled.status == StudySessionStatus.completed) _ticker?.cancel();
      if (reconciled != session) {
        await ref.read(studySessionRepositoryProvider).save(reconciled);
        state = state.copyWith(
          clearActive: true,
          lastFinishedSession: reconciled,
          remaining: Duration.zero,
        );
      } else {
        _refreshRemaining();
      }
    } finally {
      _isReconciling = false;
    }
  }

  Future<void> _transition(
    StudySession Function(StudySessionEngine, StudySession) transition,
  ) async {
    final session = state.activeSession;
    if (session == null || state.isOperating) return;
    await _operate(() async {
      final terminal = transition(
        ref.read(studySessionEngineProvider),
        session,
      );
      if (!terminal.isActive) _ticker?.cancel();
      await ref.read(studySessionRepositoryProvider).save(terminal);
      if (!terminal.isActive) {
        state = state.copyWith(
          clearActive: true,
          lastFinishedSession: terminal,
          remaining: Duration.zero,
        );
      } else {
        state = state.copyWith(activeSession: terminal);
        _refreshRemaining();
      }
    });
  }

  Future<void> _operate(Future<void> Function() action) async {
    state = state.copyWith(isOperating: true, clearFeedback: true);
    try {
      await action();
      state = state.copyWith(isOperating: false);
    } on StudySessionFailure catch (failure) {
      state = state.copyWith(
        isOperating: false,
        errorMessage: failure.safeMessage,
      );
    } on Object {
      state = state.copyWith(
        isOperating: false,
        errorMessage: 'No pudimos actualizar la sesión.',
      );
    }
  }

  Future<void> _acceptActive(StudySession? session) async {
    _ticker?.cancel();
    if (session == null) {
      final ownerId = ref.read(publicAuthSessionProvider).user?.id;
      final history = ownerId == null
          ? const <StudySession>[]
          : await ref.read(studySessionRepositoryProvider).recent(ownerId);
      if (!ref.mounted) return;
      state = state.copyWith(
        clearActive: true,
        remaining: Duration.zero,
        recentSessions: history,
      );
      return;
    }
    state = state.copyWith(activeSession: session);
    _refreshRemaining();
    if (session.status == StudySessionStatus.running) {
      if (state.remaining <= Duration.zero) {
        await reconcile();
        return;
      }
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        _refreshRemaining();
        if (state.remaining <= Duration.zero) {
          _ticker?.cancel();
          unawaited(reconcile());
        }
      });
    }
  }

  void _refreshRemaining() {
    final session = state.activeSession;
    if (session != null) {
      state = state.copyWith(
        remaining: ref.read(studySessionEngineProvider).remaining(session),
      );
    }
  }
}
