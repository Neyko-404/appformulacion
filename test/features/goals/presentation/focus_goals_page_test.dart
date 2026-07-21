import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/analytics/focus_goals_analytics_projection.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/goals/application/goals_providers.dart';
import 'package:focusly/features/goals/data/repositories/in_memory_focus_goal_repository.dart';
import 'package:focusly/features/goals/presentation/pages/focus_goals_page.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    ThemeData? theme,
    double textScale = 1,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'student@focusly.dev'),
              emailVerified: true,
            ),
          ),
          focusGoalsAnalyticsProvider.overrideWithValue(
            const FocusGoalsAnalyticsProjection(
              focusMinutesToday: 0,
              completedSessionsThisWeek: 0,
              activeDaysThisWeek: 0,
            ),
          ),
          focusGoalRepositoryProvider.overrideWithValue(
            InMemoryFocusGoalRepository(),
          ),
        ],
        child: MaterialApp(
          theme: theme,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: const FocusGoalsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows inactive suggestions and saves only explicitly', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(find.text('Metas de estudio'), findsWidgets);
    expect(find.textContaining('no se activan'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    final saveButton = find.widgetWithText(FilledButton, 'Guardar');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    expect(find.text('Tus metas se guardaron correctamente.'), findsOneWidget);
  });

  testWidgets('keeps invalid values on screen and reports their range', (
    tester,
  ) async {
    await pumpPage(tester);
    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '4');
    final saveButton = find.widgetWithText(FilledButton, 'Guardar');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump();
    expect(find.text('El valor debe estar entre 5 y 480.'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('supports dark mode and 200 percent text with scrolling', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPage(tester, theme: ThemeData.dark(), textScale: 2);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
