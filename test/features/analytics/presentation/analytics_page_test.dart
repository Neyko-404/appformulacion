import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/analytics/application/use_cases/get_analytics_summary.dart';
import 'package:focusly/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:focusly/features/analytics/domain/services/analytics_date_ranges.dart';
import 'package:focusly/features/analytics/presentation/pages/analytics_page.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/authentication/domain/entities/auth_session.dart';
import 'package:focusly/features/authentication/domain/entities/auth_user.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/study_analytics_reader.dart';

void main() {
  testWidgets('empty page is accessible in dark mode at high text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'test@focusly.dev'),
              emailVerified: true,
            ),
          ),
          analyticsClockProvider.overrideWithValue(
            _Clock(DateTime(2026, 7, 12)),
          ),
          getAnalyticsSummaryProvider.overrideWithValue(
            GetAnalyticsSummary(
              repository: const _Repository(),
              clock: _Clock(DateTime(2026, 7, 12)),
            ),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: AnalyticsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Progreso de estudio'), findsOneWidget);
    expect(
      find.textContaining('Todavía no hay suficiente actividad'),
      findsOneWidget,
    );
    expect(find.byTooltip('Actualizar resumen'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('source error exposes safe retry', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'test@focusly.dev'),
              emailVerified: true,
            ),
          ),
          analyticsClockProvider.overrideWithValue(
            _Clock(DateTime(2026, 7, 12)),
          ),
          getAnalyticsSummaryProvider.overrideWithValue(
            GetAnalyticsSummary(
              repository: const _Repository(fail: true),
              clock: _Clock(DateTime(2026, 7, 12)),
            ),
          ),
        ],
        child: const MaterialApp(home: AnalyticsPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No pudimos preparar'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('page presents weekly and monthly comparisons', (tester) async {
    final completedAt = DateTime(2026, 7, 10, 10);
    final session = StudySession(
      id: 'session-1',
      ownerId: 'user-1',
      mode: StudyMode.focus,
      status: StudySessionStatus.completed,
      plannedDuration: const Duration(minutes: 30),
      accumulatedFocusDuration: const Duration(minutes: 30),
      startedAt: completedAt.subtract(const Duration(minutes: 30)),
      completedAt: completedAt,
      createdAt: completedAt.subtract(const Duration(minutes: 30)),
      updatedAt: completedAt,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicAuthSessionProvider.overrideWithValue(
            const AuthSession.authenticated(
              user: AuthUser(id: 'user-1', email: 'test@focusly.dev'),
              emailVerified: true,
            ),
          ),
          getAnalyticsSummaryProvider.overrideWithValue(
            GetAnalyticsSummary(
              repository: _Repository(
                records: [
                  StudyAnalyticsRecord(
                    session: session,
                    interruptions: const [],
                  ),
                ],
              ),
              clock: _Clock(DateTime(2026, 7, 12)),
            ),
          ),
        ],
        child: const MaterialApp(home: AnalyticsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Comparación semanal'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Comparación mensual'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Comparación mensual'), findsOneWidget);
    expect(find.textContaining('nuevo registro'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('Insights'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Insights'), findsOneWidget);
    expect(find.text('Organiza tus materias'), findsOneWidget);
  });
}

final class _Clock implements AnalyticsClock {
  _Clock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

final class _Repository implements AnalyticsRepository {
  const _Repository({this.fail = false, this.records = const []});
  final bool fail;
  final List<StudyAnalyticsRecord> records;
  @override
  Future<AnalyticsSourceSnapshot> read(String ownerId) async {
    if (fail) throw StateError('source');
    return AnalyticsSourceSnapshot(records: records, courses: const []);
  }
}
