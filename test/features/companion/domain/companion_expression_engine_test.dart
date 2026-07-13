import 'package:flutter_test/flutter_test.dart';
import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/services/companion_expression_engine.dart';

void main() {
  const engine = CompanionExpressionEngine();

  CompanionExpressionState running(int remaining) => engine.derive(
    CompanionExpressionInput(
      isRunning: true,
      remainingDuration: Duration(minutes: remaining),
      plannedDuration: const Duration(minutes: 100),
    ),
  );

  test('derives every neutral context deterministically', () {
    final cases = <CompanionExpressionInput, CompanionContext>{
      const CompanionExpressionInput(): CompanionContext.dashboardIdle,
      const CompanionExpressionInput(isReady: true):
          CompanionContext.focusReady,
      const CompanionExpressionInput(isPaused: true):
          CompanionContext.focusPaused,
      const CompanionExpressionInput(hasInterruptionFeedback: true):
          CompanionContext.interruptionReturn,
      const CompanionExpressionInput(
        sessionOutcome: CompanionSessionOutcome.completed,
      ): CompanionContext.sessionCompleted,
      const CompanionExpressionInput(
        sessionOutcome: CompanionSessionOutcome.cancelled,
      ): CompanionContext.sessionCancelled,
      const CompanionExpressionInput(hasWeeklyProgress: true):
          CompanionContext.weeklyProgress,
      const CompanionExpressionInput(hasNoActivity: true):
          CompanionContext.noActivity,
    };
    for (final entry in cases.entries) {
      final first = engine.derive(entry.key);
      expect(first.context, entry.value);
      expect(first.message, isNotEmpty);
      expect(engine.derive(entry.key), first);
    }
  });

  test('running changes only at approved thresholds', () {
    expect(running(51).context, CompanionContext.focusRunningStart);
    expect(running(50).context, CompanionContext.focusRunningSteady);
    expect(running(21).context, CompanionContext.focusRunningSteady);
    expect(running(20).context, CompanionContext.focusRunningFinalStretch);
    expect(running(6).supportingMessage, isNull);
    expect(running(5).supportingMessage, 'Último esfuerzo.');
    expect(running(0).context, CompanionContext.focusRunningFinalStretch);
    expect(running(49).message, running(21).message);
  });

  test('invalid duration is safe and priorities prevent contradictions', () {
    expect(
      engine.derive(const CompanionExpressionInput(isRunning: true)).context,
      CompanionContext.focusRunningStart,
    );
    final completed = engine.derive(
      const CompanionExpressionInput(
        isRunning: true,
        hasInterruptionFeedback: true,
        sessionOutcome: CompanionSessionOutcome.completed,
      ),
    );
    expect(completed.context, CompanionContext.sessionCompleted);
    expect(completed.message, 'Buen trabajo.');
    expect(
      engine
          .derive(
            const CompanionExpressionInput(
              isRunning: true,
              hasInterruptionFeedback: true,
            ),
          )
          .context,
      CompanionContext.interruptionReturn,
    );
  });
}
