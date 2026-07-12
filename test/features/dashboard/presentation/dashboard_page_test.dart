import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  Future<void> pumpDashboard(WidgetTester tester) async {
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
        name: 'Kumo',
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
          dashboardOnboardingRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );
    await tester.pumpAndSettle();
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
    expect(find.text('Apariencia índigo'), findsOneWidget);
    expect(find.byType(FocusGoalCard), findsOneWidget);
    expect(find.text('Prepararme para evaluaciones'), findsOneWidget);
    expect(find.text('25 minutos'), findsOneWidget);
    expect(find.byType(FocusStreakCard), findsOneWidget);
    expect(find.text('0 días'), findsOneWidget);
    expect(find.byType(CoursesCard), findsOneWidget);
    expect(find.text('No hay cursos registrados'), findsOneWidget);
    expect(find.text('Agregar cursos'), findsOneWidget);
  });

  testWidgets('primary action exposes Study Engine entry point', (
    tester,
  ) async {
    await pumpDashboard(tester);
    final button = find.widgetWithText(FilledButton, 'Comenzar sesión');
    await tester.ensureVisible(button);
    expect(button, findsOneWidget);
  });
}
