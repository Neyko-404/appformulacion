import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';
import 'package:focusly/features/study_engine/presentation/widgets/focus_experience_widgets.dart';

void main() {
  group('focusProgress', () {
    test('calculates start, middle, end, and clamps invalid bounds', () {
      const planned = Duration(minutes: 20);
      expect(focusProgress(remaining: planned, planned: planned), 0);
      expect(
        focusProgress(remaining: const Duration(minutes: 10), planned: planned),
        0.5,
      );
      expect(focusProgress(remaining: Duration.zero, planned: planned), 1);
      expect(
        focusProgress(remaining: const Duration(minutes: 30), planned: planned),
        0,
      );
      expect(
        focusProgress(remaining: const Duration(minutes: -1), planned: planned),
        1,
      );
      expect(
        focusProgress(
          remaining: const Duration(minutes: 1),
          planned: Duration.zero,
        ),
        0,
      );
    });
  });

  testWidgets('timer exposes understandable semantics at high text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Center(
              child: FocusTimerDisplay(
                remaining: Duration(minutes: 12, seconds: 34),
                planned: Duration(minutes: 25),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('12:34'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(FocusTimerDisplay)).label,
      contains('Tiempo restante: 12 minutos, 34 segundos'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('completed result suggests rest and cancelled stays neutral', (
    tester,
  ) async {
    final completed = _session(
      status: StudySessionStatus.completed,
      duration: const Duration(minutes: 25),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionResultCard(
            session: completed,
            courseLabel: 'Cálculo',
            onHome: () {},
            onRestart: () {},
          ),
        ),
      ),
    );
    expect(find.text('Sesión completada'), findsOneWidget);
    expect(find.textContaining('descanso de 5 minutos'), findsOneWidget);
    expect(find.textContaining('Cálculo'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionResultCard(
            session: _session(
              status: StudySessionStatus.cancelled,
              duration: const Duration(minutes: 40),
            ),
            courseLabel: 'Sesión libre',
            onHome: () {},
            onRestart: () {},
          ),
        ),
      ),
    );
    expect(find.text('Sesión cancelada'), findsOneWidget);
    expect(find.textContaining('descanso de'), findsNothing);
    expect(find.textContaining('cuando quieras'), findsOneWidget);
  });
}

StudySession _session({
  required StudySessionStatus status,
  required Duration duration,
}) {
  final now = DateTime.utc(2026, 7, 12, 12);
  return StudySession(
    id: 'session-${status.name}',
    ownerId: 'user-1',
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
}
