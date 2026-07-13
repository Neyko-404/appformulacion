import 'package:focusly/features/companion/domain/entities/companion_state.dart';

enum CompanionContext {
  dashboardIdle,
  focusReady,
  focusRunningStart,
  focusRunningSteady,
  focusRunningFinalStretch,
  focusPaused,
  interruptionReturn,
  sessionCompleted,
  sessionCancelled,
  weeklyProgress,
  noActivity,
}

enum CompanionEmphasis { subtle, normal, celebratory }

enum CompanionSessionOutcome { completed, cancelled }

final class CompanionExpressionInput {
  const CompanionExpressionInput({
    this.isReady = false,
    this.isRunning = false,
    this.isPaused = false,
    this.hasInterruptionFeedback = false,
    this.sessionOutcome,
    this.remainingDuration,
    this.plannedDuration,
    this.hasWeeklyProgress = false,
    this.hasNoActivity = false,
  });

  final bool isReady;
  final bool isRunning;
  final bool isPaused;
  final bool hasInterruptionFeedback;
  final CompanionSessionOutcome? sessionOutcome;
  final Duration? remainingDuration;
  final Duration? plannedDuration;
  final bool hasWeeklyProgress;
  final bool hasNoActivity;

  @override
  bool operator ==(Object other) =>
      other is CompanionExpressionInput &&
      other.isReady == isReady &&
      other.isRunning == isRunning &&
      other.isPaused == isPaused &&
      other.hasInterruptionFeedback == hasInterruptionFeedback &&
      other.sessionOutcome == sessionOutcome &&
      other.remainingDuration == remainingDuration &&
      other.plannedDuration == plannedDuration &&
      other.hasWeeklyProgress == hasWeeklyProgress &&
      other.hasNoActivity == hasNoActivity;

  @override
  int get hashCode => Object.hash(
    isReady,
    isRunning,
    isPaused,
    hasInterruptionFeedback,
    sessionOutcome,
    remainingDuration,
    plannedDuration,
    hasWeeklyProgress,
    hasNoActivity,
  );
}

final class CompanionExpressionState {
  const CompanionExpressionState({
    required this.context,
    required this.mood,
    required this.expression,
    required this.message,
    required this.semanticLabel,
    required this.emphasis,
    this.supportingMessage,
  });

  final CompanionContext context;
  final CompanionMood mood;
  final CompanionExpression expression;
  final String message;
  final String semanticLabel;
  final CompanionEmphasis emphasis;
  final String? supportingMessage;

  @override
  bool operator ==(Object other) =>
      other is CompanionExpressionState &&
      other.context == context &&
      other.mood == mood &&
      other.expression == expression &&
      other.message == message &&
      other.semanticLabel == semanticLabel &&
      other.emphasis == emphasis &&
      other.supportingMessage == supportingMessage;

  @override
  int get hashCode => Object.hash(
    context,
    mood,
    expression,
    message,
    semanticLabel,
    emphasis,
    supportingMessage,
  );
}
