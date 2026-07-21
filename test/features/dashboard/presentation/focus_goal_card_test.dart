import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/dashboard/presentation/widgets/focus_goal_card.dart';
import 'package:focusly/features/goals/goals_public_providers.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20);
  late StudentProfile profile;

  setUp(() {
    profile = StudentProfile(
      userId: 'user-1',
      university: 'Universidad',
      career: 'Ingeniería',
      currentCycle: 3,
      primaryGoal: PrimaryGoal.routine,
      preferredFocusMinutes: 25,
      createdAt: now,
      updatedAt: now,
    );
  });

  Future<void> pumpCard(WidgetTester tester, GoalsDashboardSummary summary) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FocusGoalCard(
              profile: profile,
              goals: summary,
              onOpen: () {},
              onRetry: () {},
            ),
          ),
        ),
      );

  testWidgets('shows neutral empty configuration action', (tester) async {
    await pumpCard(tester, const GoalsDashboardSummary(isLoading: false));
    expect(
      find.text('Todavía no configuraste metas de estudio.'),
      findsOneWidget,
    );
    expect(find.text('Configurar metas'), findsOneWidget);
  });

  testWidgets('renders supplied progress without calculating it', (
    tester,
  ) async {
    await pumpCard(
      tester,
      GoalsDashboardSummary(
        isLoading: false,
        hasConfiguredGoals: true,
        progress: FocusGoalsProgress(
          dailyMinutes: FocusGoalProgress.enabled(target: 25, current: 40),
          weeklySessions: FocusGoalProgress.enabled(target: 3, current: 2),
          weeklyActiveDays: FocusGoalProgress.enabled(target: 3, current: 1),
        ),
      ),
    );
    expect(find.textContaining('40 / 25 min'), findsOneWidget);
    expect(find.text('Meta alcanzada por hoy.'), findsOneWidget);
    expect(find.text('Editar metas'), findsOneWidget);
  });

  testWidgets('keeps a Goals failure localized and recoverable', (
    tester,
  ) async {
    await pumpCard(
      tester,
      const GoalsDashboardSummary(
        isLoading: false,
        errorMessage: 'No pudimos leer tus metas.',
      ),
    );
    expect(find.text('No pudimos leer tus metas.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
