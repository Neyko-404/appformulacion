import 'package:focusly/features/companion/domain/entities/companion_expression_state.dart';
import 'package:focusly/features/companion/domain/entities/companion_state.dart';

final class CompanionExpressionEngine {
  const CompanionExpressionEngine();

  CompanionExpressionState derive(CompanionExpressionInput input) {
    if (input.sessionOutcome == CompanionSessionOutcome.completed) {
      return _state(
        CompanionContext.sessionCompleted,
        CompanionMood.celebrating,
        CompanionExpression.cheering,
        'Buen trabajo.',
        CompanionEmphasis.celebratory,
      );
    }
    if (input.hasInterruptionFeedback) {
      return _state(
        CompanionContext.interruptionReturn,
        CompanionMood.encouraging,
        CompanionExpression.normal,
        'Ya estás de vuelta.',
        CompanionEmphasis.normal,
      );
    }
    if (input.sessionOutcome == CompanionSessionOutcome.cancelled) {
      return _state(
        CompanionContext.sessionCancelled,
        CompanionMood.encouraging,
        CompanionExpression.normal,
        'Puedes intentarlo nuevamente cuando quieras.',
        CompanionEmphasis.subtle,
      );
    }
    if (input.isPaused) {
      return _state(
        CompanionContext.focusPaused,
        CompanionMood.relaxed,
        CompanionExpression.thinking,
        'Continúa cuando estés listo.',
        CompanionEmphasis.subtle,
      );
    }
    if (input.isRunning) return _running(input);
    if (input.isReady) {
      return _state(
        CompanionContext.focusReady,
        CompanionMood.encouraging,
        CompanionExpression.thinking,
        'Comienza cuando quieras.',
        CompanionEmphasis.normal,
      );
    }
    if (input.hasWeeklyProgress) {
      return _state(
        CompanionContext.weeklyProgress,
        CompanionMood.celebrating,
        CompanionExpression.happy,
        'Tu constancia está creciendo.',
        CompanionEmphasis.normal,
      );
    }
    if (input.hasNoActivity) {
      return _state(
        CompanionContext.noActivity,
        CompanionMood.resting,
        CompanionExpression.sleeping,
        'Estoy listo cuando quieras empezar.',
        CompanionEmphasis.subtle,
      );
    }
    return _state(
      CompanionContext.dashboardIdle,
      CompanionMood.relaxed,
      CompanionExpression.normal,
      'Estoy listo para acompañarte.',
      CompanionEmphasis.subtle,
    );
  }

  CompanionExpressionState _running(CompanionExpressionInput input) {
    final planned = input.plannedDuration ?? Duration.zero;
    final remaining = input.remainingDuration ?? planned;
    if (planned <= Duration.zero) {
      return _state(
        CompanionContext.focusRunningStart,
        CompanionMood.focused,
        CompanionExpression.normal,
        'Ya comenzaste.',
        CompanionEmphasis.subtle,
      );
    }
    final ratio = (remaining.inMilliseconds / planned.inMilliseconds).clamp(
      0.0,
      1.0,
    );
    if (ratio <= .20) {
      return _state(
        CompanionContext.focusRunningFinalStretch,
        CompanionMood.encouraging,
        CompanionExpression.cheering,
        'Ya casi terminas.',
        CompanionEmphasis.normal,
        supporting: ratio <= .05 ? 'Último esfuerzo.' : null,
      );
    }
    if (ratio <= .50) {
      return _state(
        CompanionContext.focusRunningSteady,
        CompanionMood.focused,
        CompanionExpression.thinking,
        'Buen ritmo.',
        CompanionEmphasis.subtle,
      );
    }
    return _state(
      CompanionContext.focusRunningStart,
      CompanionMood.focused,
      CompanionExpression.normal,
      'Ya comenzaste.',
      CompanionEmphasis.subtle,
    );
  }

  CompanionExpressionState _state(
    CompanionContext context,
    CompanionMood mood,
    CompanionExpression expression,
    String message,
    CompanionEmphasis emphasis, {
    String? supporting,
  }) => CompanionExpressionState(
    context: context,
    mood: mood,
    expression: expression,
    message: message,
    semanticLabel: '${_moodLabel(mood)}. $message',
    emphasis: emphasis,
    supportingMessage: supporting,
  );

  String _moodLabel(CompanionMood mood) => switch (mood) {
    CompanionMood.relaxed => 'Compañero tranquilo',
    CompanionMood.focused => 'Compañero concentrado',
    CompanionMood.encouraging => 'Compañero atento',
    CompanionMood.celebrating => 'Compañero celebrando',
    CompanionMood.resting => 'Compañero descansando',
  };
}
