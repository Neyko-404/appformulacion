import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/analytics_public_providers.dart';
import 'package:focusly/features/analytics/focus_goals_analytics_projection.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/goals/application/goals_providers.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_failure.dart';
import 'package:focusly/features/goals/domain/entities/focus_goal_progress.dart';
import 'package:focusly/features/goals/domain/services/focus_goals_progress_calculator.dart';
import 'package:focusly/features/goals/presentation/state/focus_goals_state.dart';

final class FocusGoalsNotifier extends Notifier<FocusGoalsState> {
  int _generation = 0;
  Future<void>? _loadOperation;
  bool _isSaving = false;

  @override
  FocusGoalsState build() {
    final ownerId = ref.watch(publicAuthSessionProvider).user?.id;
    final analytics = ref.watch(focusGoalsAnalyticsProvider);
    final generation = ++_generation;
    _loadOperation = null;
    _isSaving = false;
    scheduleMicrotask(
      () =>
          _load(ownerId: ownerId, analytics: analytics, generation: generation),
    );
    return const FocusGoalsState();
  }

  Future<void> refresh() {
    final active = _loadOperation;
    if (active != null) return active;
    final operation = _load(
      ownerId: ref.read(publicAuthSessionProvider).user?.id,
      analytics: ref.read(focusGoalsAnalyticsProvider),
      generation: _generation,
    );
    _loadOperation = operation;
    operation.whenComplete(() {
      if (identical(_loadOperation, operation)) _loadOperation = null;
    });
    return operation;
  }

  Future<bool> save({
    required int? dailyMinutesTarget,
    required int? weeklyCompletedSessionsTarget,
    required int? weeklyActiveDaysTarget,
  }) async {
    if (_isSaving) return false;
    final ownerId = ref.read(publicAuthSessionProvider).user?.id;
    if (ownerId == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Necesitas una sesión válida para guardar metas.',
        clearSuccess: true,
      );
      return false;
    }

    final now = ref.read(focusGoalsClockProvider)();
    FocusGoal goal;
    try {
      goal = FocusGoal(
        ownerId: ownerId,
        dailyMinutesTarget: dailyMinutesTarget,
        weeklyCompletedSessionsTarget: weeklyCompletedSessionsTarget,
        weeklyActiveDaysTarget: weeklyActiveDaysTarget,
        createdAt: state.goal?.createdAt ?? now,
        updatedAt: now,
      );
    } on FocusGoalFailure catch (failure) {
      state = state.copyWith(
        errorMessage: failure.safeMessage,
        clearSuccess: true,
      );
      return false;
    }

    _isSaving = true;
    final generation = _generation;
    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      await ref.read(saveFocusGoalProvider)(goal);
      if (!_isCurrent(ownerId, generation)) return false;
      state = state.copyWith(
        goal: goal,
        progress: _progress(goal, ref.read(focusGoalsAnalyticsProvider)),
        isSaving: false,
        successMessage: 'Tus metas se guardaron correctamente.',
        clearError: true,
      );
      return true;
    } on FocusGoalFailure catch (failure) {
      if (_isCurrent(ownerId, generation)) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: failure.safeMessage,
          clearSuccess: true,
        );
      }
      return false;
    } on Object {
      if (_isCurrent(ownerId, generation)) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: FocusGoalFailure.unexpected().safeMessage,
          clearSuccess: true,
        );
      }
      return false;
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _load({
    required String? ownerId,
    required FocusGoalsAnalyticsProjection? analytics,
    required int generation,
  }) async {
    if (ownerId == null) {
      if (generation == _generation) {
        state = const FocusGoalsState(
          isLoading: false,
          errorMessage: 'Necesitas una sesión válida para consultar metas.',
        );
      }
      return;
    }
    try {
      final result = analytics == null
          ? (
              goal: await ref.read(getFocusGoalProvider)(ownerId),
              progress: null,
            )
          : await ref.read(getFocusGoalsProgressProvider)(
              ownerId: ownerId,
              analytics: analytics,
            );
      if (!_isCurrent(ownerId, generation)) return;
      state = FocusGoalsState(
        goal: result.goal,
        progress: result.progress,
        isLoading: false,
      );
    } on FocusGoalFailure catch (failure) {
      if (!_isCurrent(ownerId, generation)) return;
      state = FocusGoalsState(
        isLoading: false,
        errorMessage: failure.safeMessage,
      );
    } on Object {
      if (!_isCurrent(ownerId, generation)) return;
      state = FocusGoalsState(
        isLoading: false,
        errorMessage: FocusGoalFailure.unexpected().safeMessage,
      );
    }
  }

  FocusGoalsProgress? _progress(
    FocusGoal goal,
    FocusGoalsAnalyticsProjection? analytics,
  ) => analytics == null
      ? null
      : const FocusGoalsProgressCalculator().calculate(
          goal: goal,
          analytics: analytics,
        );

  bool _isCurrent(String ownerId, int generation) =>
      ref.mounted &&
      generation == _generation &&
      ref.read(publicAuthSessionProvider).user?.id == ownerId;
}
