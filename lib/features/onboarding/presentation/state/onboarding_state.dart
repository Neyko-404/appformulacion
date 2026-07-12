import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';

enum OnboardingStep { welcome, academic, goal, preferences, companion, summary }

final class OnboardingDraft {
  const OnboardingDraft({
    this.university = 'UNJFSC',
    this.career = '',
    this.currentCycle,
    this.primaryGoal,
    this.preferredFocusMinutes = 25,
    this.companionName = '',
    this.appearance,
  });

  final String university;
  final String career;
  final int? currentCycle;
  final PrimaryGoal? primaryGoal;
  final int preferredFocusMinutes;
  final String companionName;
  final CompanionAppearance? appearance;

  OnboardingDraft copyWith({
    String? university,
    String? career,
    int? currentCycle,
    PrimaryGoal? primaryGoal,
    int? preferredFocusMinutes,
    String? companionName,
    CompanionAppearance? appearance,
  }) {
    return OnboardingDraft(
      university: university ?? this.university,
      career: career ?? this.career,
      currentCycle: currentCycle ?? this.currentCycle,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      preferredFocusMinutes:
          preferredFocusMinutes ?? this.preferredFocusMinutes,
      companionName: companionName ?? this.companionName,
      appearance: appearance ?? this.appearance,
    );
  }
}

final class OnboardingState {
  const OnboardingState({
    required this.userId,
    this.isInitializing = true,
    this.step = OnboardingStep.welcome,
    this.draft = const OnboardingDraft(),
    this.isSaving = false,
    this.isCompleted = false,
    this.validationMessage,
    this.errorMessage,
  });

  final String? userId;
  final bool isInitializing;
  final OnboardingStep step;
  final OnboardingDraft draft;
  final bool isSaving;
  final bool isCompleted;
  final String? validationMessage;
  final String? errorMessage;

  int get stepNumber => step.index + 1;
  int get totalSteps => OnboardingStep.values.length;

  OnboardingState copyWith({
    bool? isInitializing,
    OnboardingStep? step,
    OnboardingDraft? draft,
    bool? isSaving,
    bool? isCompleted,
    String? validationMessage,
    String? errorMessage,
    bool clearMessages = false,
  }) {
    return OnboardingState(
      userId: userId,
      isInitializing: isInitializing ?? this.isInitializing,
      step: step ?? this.step,
      draft: draft ?? this.draft,
      isSaving: isSaving ?? this.isSaving,
      isCompleted: isCompleted ?? this.isCompleted,
      validationMessage: clearMessages
          ? null
          : validationMessage ?? this.validationMessage,
      errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    );
  }
}
