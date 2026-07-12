import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/study_engine/domain/entities/study_session.dart';

final class StudyEngineState {
  const StudyEngineState({
    this.isInitializing = true,
    this.selectedDuration = const Duration(minutes: 25),
    this.remaining = Duration.zero,
    this.recentSessions = const [],
    this.isOperating = false,
    this.activeSession,
    this.lastFinishedSession,
    this.selectedCourseId,
    this.errorMessage,
    this.message,
    this.companion,
  });
  final bool isInitializing;
  final StudySession? activeSession;
  final StudySession? lastFinishedSession;
  final Duration selectedDuration;
  final String? selectedCourseId;
  final Duration remaining;
  final List<StudySession> recentSessions;
  final bool isOperating;
  final String? errorMessage;
  final String? message;
  final StudyCompanion? companion;

  StudyEngineState copyWith({
    bool? isInitializing,
    StudySession? activeSession,
    bool clearActive = false,
    StudySession? lastFinishedSession,
    bool clearLastFinished = false,
    Duration? selectedDuration,
    String? selectedCourseId,
    bool clearCourse = false,
    Duration? remaining,
    List<StudySession>? recentSessions,
    bool? isOperating,
    String? errorMessage,
    String? message,
    bool clearFeedback = false,
    StudyCompanion? companion,
  }) => StudyEngineState(
    isInitializing: isInitializing ?? this.isInitializing,
    activeSession: clearActive ? null : activeSession ?? this.activeSession,
    lastFinishedSession: clearLastFinished
        ? null
        : lastFinishedSession ?? this.lastFinishedSession,
    selectedDuration: selectedDuration ?? this.selectedDuration,
    selectedCourseId: clearCourse
        ? null
        : selectedCourseId ?? this.selectedCourseId,
    remaining: remaining ?? this.remaining,
    recentSessions: recentSessions ?? this.recentSessions,
    isOperating: isOperating ?? this.isOperating,
    errorMessage: clearFeedback ? null : errorMessage ?? this.errorMessage,
    message: clearFeedback ? null : message ?? this.message,
    companion: companion ?? this.companion,
  );
}
