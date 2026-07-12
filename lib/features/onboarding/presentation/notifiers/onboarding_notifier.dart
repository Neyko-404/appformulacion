import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/onboarding/domain/entities/onboarding_failure.dart';
import 'package:focusly/features/onboarding/domain/entities/student_profile.dart';
import 'package:focusly/features/onboarding/domain/entities/study_companion.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';
import 'package:focusly/features/onboarding/presentation/state/onboarding_state.dart';

final class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    final userId = ref.watch(publicAuthSessionProvider).user?.id;
    final initial = OnboardingState(userId: userId);
    scheduleMicrotask(_initialize);
    return initial;
  }

  Future<void> _initialize() async {
    final userId = state.userId;
    if (userId == null) {
      state = state.copyWith(
        isInitializing: false,
        errorMessage: 'Necesitas una sesión válida para continuar.',
      );
      return;
    }
    try {
      final completed = await ref
          .read(onboardingRepositoryProvider)
          .isCompleted(userId);
      if (state.userId != userId) {
        return;
      }
      state = state.copyWith(
        isInitializing: false,
        isCompleted: completed,
        clearMessages: true,
      );
    } on OnboardingFailure catch (failure) {
      if (state.userId != userId) {
        return;
      }
      state = state.copyWith(
        isInitializing: false,
        errorMessage: failure.safeMessage,
      );
    } on Object {
      if (state.userId != userId) return;
      state = state.copyWith(
        isInitializing: false,
        errorMessage: 'No pudimos preparar la configuración inicial.',
      );
    }
  }

  void retryInitialization() {
    if (state.isInitializing || state.isSaving) return;
    state = OnboardingState(userId: state.userId);
    unawaited(_initialize());
  }

  void updateUniversity(String value) =>
      _updateDraft(state.draft.copyWith(university: value));

  void updateCareer(String value) =>
      _updateDraft(state.draft.copyWith(career: value));

  void updateCycle(int value) =>
      _updateDraft(state.draft.copyWith(currentCycle: value));

  void updateGoal(PrimaryGoal value) =>
      _updateDraft(state.draft.copyWith(primaryGoal: value));

  void updateFocusMinutes(int value) =>
      _updateDraft(state.draft.copyWith(preferredFocusMinutes: value));

  void updateCompanionName(String value) =>
      _updateDraft(state.draft.copyWith(companionName: value));

  void updateAppearance(CompanionAppearance value) =>
      _updateDraft(state.draft.copyWith(appearance: value));

  bool next() {
    final error = _validateStep(state.step);
    if (error != null) {
      state = state.copyWith(validationMessage: error);
      return false;
    }
    if (state.step != OnboardingStep.summary) {
      state = state.copyWith(
        step: OnboardingStep.values[state.step.index + 1],
        clearMessages: true,
      );
    }
    return true;
  }

  void previous() {
    if (state.step.index > 0 && !state.isSaving) {
      state = state.copyWith(
        step: OnboardingStep.values[state.step.index - 1],
        clearMessages: true,
      );
    }
  }

  Future<void> complete() async {
    if (state.isSaving || state.userId == null) {
      return;
    }
    final error = _validateAll();
    if (error != null) {
      state = state.copyWith(validationMessage: error);
      return;
    }

    state = state.copyWith(isSaving: true, clearMessages: true);
    final now = ref.read(onboardingClockProvider)();
    final userId = state.userId!;
    final validator = ref.read(onboardingValidatorProvider);
    final draft = state.draft;
    try {
      await ref
          .read(onboardingRepositoryProvider)
          .saveOnboarding(
            profile: StudentProfile(
              userId: userId,
              university: draft.university.trim(),
              career: draft.career.trim(),
              currentCycle: draft.currentCycle!,
              primaryGoal: draft.primaryGoal!,
              preferredFocusMinutes: draft.preferredFocusMinutes,
              createdAt: now,
              updatedAt: now,
            ),
            companion: StudyCompanion(
              id: 'companion-$userId',
              ownerId: userId,
              name: validator.normalizeName(draft.companionName),
              appearance: draft.appearance!,
              createdAt: now,
            ),
          );
      state = state.copyWith(
        isSaving: false,
        isCompleted: true,
        clearMessages: true,
      );
    } on Object {
      state = state.copyWith(
        isSaving: false,
        errorMessage:
            'No pudimos guardar tu configuración. Inténtalo nuevamente.',
      );
    }
  }

  void _updateDraft(OnboardingDraft draft) {
    if (!state.isSaving) {
      state = state.copyWith(draft: draft, clearMessages: true);
    }
  }

  String? _validateStep(OnboardingStep step) {
    final validator = ref.read(onboardingValidatorProvider);
    final draft = state.draft;
    return switch (step) {
      OnboardingStep.welcome => null,
      OnboardingStep.academic =>
        validator.requiredText(draft.university, 'La universidad') ??
            validator.requiredText(draft.career, 'La carrera') ??
            validator.cycle(draft.currentCycle),
      OnboardingStep.goal => validator.goal(draft.primaryGoal),
      OnboardingStep.preferences => validator.focusMinutes(
        draft.preferredFocusMinutes,
      ),
      OnboardingStep.companion =>
        validator.companionName(draft.companionName) ??
            validator.appearance(draft.appearance),
      OnboardingStep.summary => _validateAll(),
    };
  }

  String? _validateAll() {
    for (final step in OnboardingStep.values.where(
      (value) => value != OnboardingStep.summary,
    )) {
      final error = _validateStep(step);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
