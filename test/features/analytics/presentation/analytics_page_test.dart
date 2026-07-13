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
}

final class _Clock implements AnalyticsClock {
  _Clock(this.value);
  final DateTime value;
  @override
  DateTime now() => value;
}

final class _Repository implements AnalyticsRepository {
  const _Repository({this.fail = false});
  final bool fail;
  @override
  Future<AnalyticsSourceSnapshot> read(String ownerId) async {
    if (fail) throw StateError('source');
    return const AnalyticsSourceSnapshot(records: [], courses: []);
  }
}
