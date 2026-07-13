import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/academic_tracker/course_public_providers.dart';
import 'package:focusly/features/academic_tracker/domain/entities/course.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/analytics/domain/entities/study_trends.dart';
import 'package:focusly/features/analytics/domain/services/trend_calculator.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/dashboard/dashboard_providers.dart';
import 'package:focusly/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:focusly/features/dashboard/presentation/widgets/courses_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/focus_goal_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/focus_streak_card.dart';
import 'package:focusly/features/dashboard/presentation/widgets/study_companion_card.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_engine_public_providers.dart';

void main() {
  test('dashboard trend distinguishes all zero-data cases', () {
    const calculator = TrendCalculator();
    expect(projectDashboardWeeklyTrend(calculator.compare(0, 0)), isNull);
    expect(
      projectDashboardWeeklyTrend(calculator.compare(30, 0))?.message,
      'Comenzaste a sumar tiempo de estudio esta semana.',
    );
    expect(
      projectDashboardWeeklyTrend(calculator.compare(0, 30))?.message,
      'Esta semana aún no registras tiempo de estudio.',
    );
    expect(
      projectDashboardWeeklyTrend(calculator.compare(30, 30))?.message,
      'Mantienes un ritmo similar a la semana pasada.',
    );
  });

  Future<void> pumpDashboard(
    WidgetTester tester, {
    ActiveStudySummary study = const ActiveStudySummary(
      remaining: Duration.zero,
    ),
    TodayAnalyticsProjection analytics = const TodayAnalyticsProjection(
      isLoading: false,
      focusedDuration: Duration.zero,
      completedSessions: 0,
      interruptionCount: 0,
      interruptionDuration: Duration.zero,
    ),
    List<Course> courses = const [],
    String companionName = 'Kumo',
    String? coursesError,
    bool coursesLoading = false,
    Object? analyticsError,
    bool analyticsLoading = false,
    ThemeData? theme,
    double textScale = 1,
    OnboardingRepository? onboardingRepository,
    Future<TodayAnalyticsProjection> Function()? analyticsLoader,
  }) async {
    final now = DateTime.utc(2026, 7, 12);
    final repository = InMemoryOnboardingRepository();
    await repository.saveOnboarding(
      profile: StudentProfile(
        userId: 'user-1',
        university: 'UNJFSC',
        career: 'Ingeniería',
        currentCycle: 4,
        primaryGoal: PrimaryGoal.examPreparation,
        preferredFocusMinutes: 25,
        createdAt: now,
        updatedAt: now,
      ),
      companion: StudyCompanion(
        id: 'cat-1',
        ownerId: 'user-1',
        name: companionName,
        appearance: CompanionAppearance.indigo,
        createdAt: now,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'gary@focusly.dev'),
              emailVerified: true,
            ),
          ),
          dashboardOnboardingRepositoryProvider.overrideWithValue(
            onboardingRepository ?? repository,
          ),
          activeStudySummaryProvider.overrideWithValue(study),
          if (analyticsLoader != null)
            dashboardTodayAnalyticsProvider.overrideWith(
              (ref) => analyticsLoader(),
            )
          else
            dashboardTodayAnalyticsProvider.overrideWithValue(
              analyticsError != null
                  ? AsyncError(analyticsError, StackTrace.empty)
                  : analyticsLoading
                  ? const AsyncLoading()
                  : AsyncData(analytics),
            ),
          activeCoursesProvider.overrideWithValue(
            ActiveCoursesSnapshot(
              courses: courses,
              isLoading: coursesLoading,
              errorMessage: coursesError,
            ),
          ),
        ],
        child: MaterialApp(
          theme: theme,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: const DashboardPage(),
          ),
        ),
      ),
    );
    if (analyticsLoading || coursesLoading) {
      for (var index = 0; index < 10; index++) {
        await tester.pump(const Duration(milliseconds: 20));
      }
    } else {
      await tester.pumpAndSettle();
    }
  }

  testWidgets('renders dashboard foundation cards responsively', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpDashboard(tester);

    expect(find.textContaining('Gary'), findsOneWidget);
    expect(find.byType(StudyCompanionCard), findsOneWidget);
    expect(find.text('Kumo'), findsOneWidget);
    expect(find.text('Organicemos tu próximo paso.'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    expect(find.textContaining('apariencia'), findsNothing);
    expect(find.byType(FocusGoalCard), findsOneWidget);
    expect(find.text('Prepararme para evaluaciones'), findsOneWidget);
    expect(find.text('Sesiones sugeridas de 25 min'), findsOneWidget);
    expect(find.byType(FocusStreakCard), findsNothing);
    expect(find.byType(CoursesCard), findsOneWidget);
    expect(find.text('Hoy'), findsOneWidget);
    expect(find.text('0 minutos'), findsOneWidget);
    expect(find.text('0'), findsWidgets);
    expect(find.textContaining('Sin datos todavía'), findsOneWidget);
    expect(find.textContaining('Tiempo perdido'), findsNothing);
    expect(
      find.text('Todavía no tienes cursos.\nAgrega uno para comenzar.'),
      findsOneWidget,
    );
    expect(find.text('Agregar cursos'), findsOneWidget);
    expect(find.text('Comenzar sesión'), findsWidgets);
    expect(find.text('Sesión sugerida de 25 min'), findsOneWidget);
  });

  testWidgets('shows read-only analytics values without calculating them', (
    tester,
  ) async {
    await pumpDashboard(
      tester,
      analytics: const TodayAnalyticsProjection(
        isLoading: false,
        focusedDuration: Duration(minutes: 85),
        completedSessions: 3,
        interruptionCount: 2,
        interruptionDuration: Duration(minutes: 4),
        mostStudiedCourseName: 'Cálculo',
        weeklyTrend: DashboardTrendProjection(
          message: '15 % más tiempo que la semana pasada.',
          direction: TrendDirection.up,
        ),
      ),
    );
    expect(find.text('1 h 25 min'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.textContaining('Cálculo'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Ver progreso'), findsOneWidget);
    expect(find.text('Tendencia'), findsOneWidget);
    expect(find.textContaining('15 % más tiempo'), findsOneWidget);
    expect(find.byIcon(Icons.trending_up), findsOneWidget);
  });

  testWidgets('primary action exposes Study Engine entry point', (
    tester,
  ) async {
    await pumpDashboard(tester);
    final button = find.widgetWithText(FilledButton, 'Comenzar sesión');
    await tester.ensureVisible(button);
    expect(button, findsOneWidget);
  });

  testWidgets('primary action distinguishes running and paused sessions', (
    tester,
  ) async {
    final now = DateTime.utc(2026, 7, 12, 10);
    final running = StudySession(
      id: 'session-1',
      ownerId: 'user-1',
      mode: StudyMode.focus,
      status: StudySessionStatus.running,
      plannedDuration: const Duration(minutes: 25),
      accumulatedFocusDuration: Duration.zero,
      startedAt: now,
      plannedEndAt: now.add(const Duration(minutes: 25)),
      createdAt: now,
      updatedAt: now,
    );
    await pumpDashboard(
      tester,
      study: ActiveStudySummary(
        session: running,
        remaining: const Duration(minutes: 12),
      ),
    );
    expect(find.text('Continuar sesión'), findsWidgets);
    expect(find.textContaining('En curso · 12:00'), findsOneWidget);
    expect(find.text('Buen ritmo.'), findsOneWidget);

    await pumpDashboard(
      tester,
      study: ActiveStudySummary(
        session: running.copyWith(
          status: StudySessionStatus.paused,
          accumulatedFocusDuration: const Duration(minutes: 5),
          pausedAt: now,
          clearPlannedEndAt: true,
        ),
        remaining: const Duration(minutes: 20),
      ),
    );
    expect(find.text('Retomar sesión'), findsWidgets);
    expect(find.textContaining('Pausada · 20:00'), findsOneWidget);
    expect(
      find.text('Tómate un momento. Continúa cuando estés listo.'),
      findsOneWidget,
    );
  });

  testWidgets('secondary loading and errors remain localized', (tester) async {
    await pumpDashboard(tester, analyticsLoading: true);
    await tester.ensureVisible(find.text('Hoy'));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Comenzar sesión'), findsWidgets);
    expect(find.text('Kumo'), findsOneWidget);
    expect(find.text('Preparando tu resumen'), findsOneWidget);
    expect(find.text('Agrega tu primer curso'), findsNothing);
    expect(find.text('Puedes comenzar con una sesión corta.'), findsNothing);

    await pumpDashboard(tester, coursesLoading: true);
    expect(find.text('Preparando tu resumen'), findsOneWidget);
    expect(find.text('Agrega tu primer curso'), findsNothing);

    await pumpDashboard(
      tester,
      analyticsError: StateError('source'),
      coursesError: 'safe course error',
    );
    expect(
      find.text('No pudimos actualizar el resumen de hoy.'),
      findsOneWidget,
    );
    expect(find.text('No pudimos actualizar tus cursos.'), findsOneWidget);
    expect(find.text('Kumo'), findsOneWidget);
    expect(find.text('Preparando tu resumen'), findsOneWidget);
  });

  testWidgets('supports narrow dark layout, long names and 200 percent text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final now = DateTime.utc(2026, 7, 12);
    await pumpDashboard(
      tester,
      companionName: 'Compañero de estudio con nombre muy largo',
      textScale: 2,
      theme: ThemeData.dark(),
      courses: [
        Course(
          id: 'course-1',
          ownerId: 'user-1',
          name: 'Curso universitario con un nombre especialmente extenso',
          visualIdentity: CourseVisualIdentity.ocean,
          status: CourseStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('Compañero de estudio'), findsOneWidget);
    expect(find.textContaining('Curso universitario'), findsOneWidget);
  });

  testWidgets('refresh action remains explicit and safe', (tester) async {
    final now = DateTime.utc(2026, 7, 12);
    final repository = _CountingOnboardingRepository(
      profile: StudentProfile(
        userId: 'user-1',
        university: 'UNJFSC',
        career: 'Ingeniería',
        currentCycle: 4,
        primaryGoal: PrimaryGoal.examPreparation,
        preferredFocusMinutes: 25,
        createdAt: now,
        updatedAt: now,
      ),
      companion: StudyCompanion(
        id: 'cat-1',
        ownerId: 'user-1',
        name: 'Kumo',
        appearance: CompanionAppearance.indigo,
        createdAt: now,
      ),
    );
    var analyticsLoads = 0;
    final refreshCompleter = Completer<TodayAnalyticsProjection>();
    const analytics = TodayAnalyticsProjection(
      isLoading: false,
      focusedDuration: Duration(minutes: 15),
      completedSessions: 1,
      interruptionCount: 0,
      interruptionDuration: Duration.zero,
    );
    await pumpDashboard(
      tester,
      onboardingRepository: repository,
      analyticsLoader: () {
        analyticsLoads++;
        return analyticsLoads == 1
            ? Future.value(analytics)
            : refreshCompleter.future;
      },
    );
    expect(analyticsLoads, 1);
    expect(repository.profileReads, 1);
    await tester.tap(find.byTooltip('Actualizar inicio'));
    await tester.tap(find.byTooltip('Actualizar inicio'));
    await tester.pump();
    expect(analyticsLoads, 2);
    expect(repository.profileReads, 2);
    expect(repository.companionReads, 2);
    expect(find.text('15 minutos'), findsOneWidget);
    refreshCompleter.completeError(StateError('partial analytics failure'));
    await tester.pumpAndSettle();
    expect(find.text('Kumo'), findsOneWidget);
    expect(
      find.text('No pudimos actualizar el resumen de hoy.'),
      findsOneWidget,
    );
  });
}

final class _CountingOnboardingRepository implements OnboardingRepository {
  _CountingOnboardingRepository({
    required this.profile,
    required this.companion,
  });

  final StudentProfile profile;
  final StudyCompanion companion;
  int profileReads = 0;
  int companionReads = 0;

  @override
  Future<StudentProfile?> getProfile(String userId) async {
    profileReads++;
    return profile;
  }

  @override
  Future<StudyCompanion?> getCompanion(String userId) async {
    companionReads++;
    return companion;
  }

  @override
  Future<bool> isCompleted(String userId) async => true;

  @override
  Future<void> clear(String userId) async {}

  @override
  Future<void> saveOnboarding({
    required StudentProfile profile,
    required StudyCompanion companion,
  }) async {}
}
