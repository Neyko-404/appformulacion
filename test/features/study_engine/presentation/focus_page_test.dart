import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/study_engine/data/repositories/in_memory_study_session_repository.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/domain/services/study_clock.dart';
import 'package:focusly/features/study_engine/presentation/notifiers/study_engine_notifier.dart';
import 'package:focusly/features/study_engine/presentation/pages/focus_history_page.dart';
import 'package:focusly/features/study_engine/presentation/pages/focus_page.dart';
import 'package:focusly/features/study_engine/study_engine_providers.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('preparation selects duration, course, and starts running', (
    tester,
  ) async {
    final harness = await _FocusHarness.pump(tester);
    addTearDown(harness.dispose);

    expect(find.text('Prepara tu sesión'), findsOneWidget);
    expect(find.text('Seleccionada: 25 minutos'), findsOneWidget);
    expect(find.text('Sesión libre'), findsOneWidget);
    expect(find.byTooltip('Ver historial de enfoque'), findsOneWidget);

    await tester.tap(find.text('15 min'));
    await tester.pump();
    expect(find.text('Seleccionada: 15 minutos'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_longCourseName).last);
    await tester.pumpAndSettle();
    expect(find.textContaining('Estudiarás:'), findsOneWidget);

    await harness.notifier.start();
    await _pumpInteraction(tester);
    expect(find.text('En curso'), findsOneWidget);
    expect(find.text('Pausar'), findsOneWidget);
    expect(find.text('15:00'), findsOneWidget);
    expect(
      (await harness.repository.getActive('user-1'))?.courseId,
      'course-1',
    );
  });

  testWidgets('paused state is clear and cancellation is confirmed', (
    tester,
  ) async {
    final harness = await _FocusHarness.pump(tester);
    addTearDown(harness.dispose);
    await harness.notifier.start();
    await _pumpInteraction(tester);
    await harness.notifier.pause();
    await _pumpInteraction(tester);

    expect(find.text('Sesión pausada'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
    expect(find.textContaining('continúa cuando estés listo'), findsOneWidget);

    final cancelButton = find.text('Cancelar sesión');
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
    expect(find.text('Seguir estudiando'), findsOneWidget);
    expect(find.textContaining('se registrará como cancelada'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Cancelar sesión'));
    await _pumpInteraction(tester);

    expect(find.text('Sesión cancelada'), findsOneWidget);
    expect(find.textContaining('cuando quieras'), findsOneWidget);
    expect(find.text('Sesión completada'), findsNothing);
    expect((await harness.repository.recent('user-1')), hasLength(1));
  });

  testWidgets('back is normal without a session and explicit while active', (
    tester,
  ) async {
    final harness = await _FocusHarness.pump(tester);
    addTearDown(harness.dispose);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Dashboard de prueba'), findsOneWidget);

    harness.router.push('/focus');
    await tester.pumpAndSettle();
    await harness.notifier.start();
    await _pumpInteraction(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Tu sesión sigue activa'), findsOneWidget);
    expect(find.text('Salir y mantenerla activa'), findsOneWidget);
    await tester.tap(find.text('Salir y mantenerla activa'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard de prueba'), findsOneWidget);
    expect(await harness.repository.getActive('user-1'), isNotNull);

    harness.router.push('/focus');
    await tester.pumpAndSettle();
    await harness.notifier.pause();
    await _pumpInteraction(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Tu sesión sigue activa'), findsOneWidget);
    await tester.tap(find.text('Continuar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Sesión pausada'), findsOneWidget);
  });

  testWidgets('completed result shows summary, rest, and can restart', (
    tester,
  ) async {
    final harness = await _FocusHarness.pump(tester);
    addTearDown(harness.dispose);
    await harness.notifier.start();
    await _pumpInteraction(tester);
    harness.clock.advance(const Duration(minutes: 25));
    await harness.notifier.reconcile();
    await _pumpInteraction(tester);

    expect(find.text('Sesión completada'), findsOneWidget);
    expect(find.textContaining('Tiempo enfocado: 25 minutos'), findsOneWidget);
    expect(find.textContaining('descanso de 5 minutos'), findsOneWidget);
    expect(find.text('Volver al inicio'), findsOneWidget);

    await tester.tap(find.text('Iniciar otra sesión'));
    await _pumpInteraction(tester);
    expect(find.text('Prepara tu sesión'), findsOneWidget);
  });

  testWidgets('history shows empty and natural terminal entries', (
    tester,
  ) async {
    final harness = await _FocusHarness.pump(tester, openHistory: true);
    addTearDown(harness.dispose);
    expect(
      find.text('Todavía no has realizado ninguna sesión.'),
      findsOneWidget,
    );

    final now = harness.clock.now();
    await harness.repository.save(
      _terminal(
        id: 'completed',
        status: StudySessionStatus.completed,
        duration: const Duration(minutes: 1),
        now: now,
        courseId: 'course-1',
      ),
    );
    await harness.repository.save(
      _terminal(
        id: 'cancelled',
        status: StudySessionStatus.cancelled,
        duration: const Duration(minutes: 2),
        now: now,
      ),
    );
    await harness.notifier.refreshHistory();
    await tester.pump();

    expect(find.text('Sesión completada'), findsOneWidget);
    expect(find.text('Sesión cancelada'), findsOneWidget);
    expect(find.textContaining('1 minuto'), findsOneWidget);
    expect(find.textContaining('2 minutos'), findsOneWidget);
    expect(find.textContaining(_longCourseName), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}

Future<void> _pumpInteraction(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

const _longCourseName =
    'Cálculo diferencial e integral para ingeniería aplicada';

final class _FocusHarness {
  _FocusHarness(this.router, this.repository, this.clock, this.container);

  final GoRouter router;
  final InMemoryStudySessionRepository repository;
  final _FakeClock clock;
  final ProviderContainer container;

  StudyEngineNotifier get notifier =>
      container.read(studyEngineNotifierProvider.notifier);

  static Future<_FocusHarness> pump(
    WidgetTester tester, {
    bool openHistory = false,
  }) async {
    final repository = InMemoryStudySessionRepository();
    final clock = _FakeClock(DateTime.utc(2026, 7, 12, 10));
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (_, _) => const Scaffold(body: Text('Dashboard de prueba')),
        ),
        GoRoute(path: '/focus', builder: (_, _) => const FocusPage()),
        GoRoute(
          path: '/focus/history',
          builder: (_, _) => const FocusHistoryPage(),
        ),
      ],
    );
    final overrides = [
      publicAuthSessionProvider.overrideWithValue(
        const AuthSession.authenticated(
          user: AuthUser(id: 'user-1', email: 'test@focusly.dev'),
          emailVerified: true,
        ),
      ),
      onboardingRepositoryProvider.overrideWithValue(
        InMemoryOnboardingRepository(),
      ),
      studySessionRepositoryProvider.overrideWithValue(repository),
      studyClockProvider.overrideWithValue(clock),
      activeCoursesProvider.overrideWithValue(
        ActiveCoursesSnapshot(
          courses: [_course(clock.now())],
          isLoading: false,
        ),
      ),
    ];
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    router.push(openHistory ? '/focus/history' : '/focus');
    await tester.pumpAndSettle();
    return _FocusHarness(router, repository, clock, container);
  }

  void dispose() {
    repository.dispose();
  }
}

Course _course(DateTime now) => Course(
  id: 'course-1',
  ownerId: 'user-1',
  name: _longCourseName,
  visualIdentity: CourseVisualIdentity.ocean,
  status: CourseStatus.active,
  createdAt: now,
  updatedAt: now,
);

StudySession _terminal({
  required String id,
  required StudySessionStatus status,
  required Duration duration,
  required DateTime now,
  String? courseId,
}) => StudySession(
  id: id,
  ownerId: 'user-1',
  courseId: courseId,
  mode: StudyMode.focus,
  status: status,
  plannedDuration: duration,
  accumulatedFocusDuration: duration,
  startedAt: now.subtract(duration),
  completedAt: status == StudySessionStatus.completed ? now : null,
  cancelledAt: status == StudySessionStatus.cancelled ? now : null,
  createdAt: now.subtract(duration),
  updatedAt: now,
);

final class _FakeClock implements StudyClock {
  _FakeClock(this.value);
  DateTime value;
  @override
  DateTime now() => value;
  void advance(Duration duration) => value = value.add(duration);
}
