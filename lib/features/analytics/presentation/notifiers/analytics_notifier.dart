import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/analytics/application/providers/analytics_providers.dart';
import 'package:focusly/features/analytics/domain/failures/analytics_failure.dart';
import 'package:focusly/features/analytics/presentation/state/analytics_state.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/study_engine/study_analytics_read_api.dart';

final class AnalyticsNotifier extends Notifier<AnalyticsState> {
  bool _isOperating = false;
  bool _refreshPending = false;
  int _generation = 0;

  @override
  AnalyticsState build() {
    final generation = ++_generation;
    _isOperating = false;
    _refreshPending = false;
    final ownerId = ref.watch(publicAuthSessionProvider).user?.id;
    ref.listen(studyAnalyticsRevisionProvider, (previous, next) {
      if (previous != null && previous != next) {
        unawaited(_requestRefresh());
      }
    });
    scheduleMicrotask(
      () => _load(ownerId, refresh: false, generation: generation),
    );
    return const AnalyticsState();
  }

  Future<void> refresh() => _requestRefresh();

  Future<void> _requestRefresh() async {
    if (_isOperating) {
      _refreshPending = true;
      return;
    }
    await _load(
      ref.read(publicAuthSessionProvider).user?.id,
      refresh: true,
      generation: _generation,
    );
  }

  Future<void> _load(
    String? ownerId, {
    required bool refresh,
    required int generation,
  }) async {
    if (_isOperating) return;
    _isOperating = true;
    state = state.copyWith(
      isInitial: false,
      isLoading: state.summary == null,
      isRefreshing: refresh && state.summary != null,
      clearError: true,
    );
    try {
      final summary = await ref.read(getAnalyticsSummaryProvider)(ownerId);
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        summary: summary,
        lastUpdatedAt: ref.read(analyticsClockProvider).now(),
      );
    } on AnalyticsFailure catch (failure) {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: failure.safeMessage,
      );
    } on Object {
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'No pudimos preparar tu resumen de estudio.',
      );
    } finally {
      if (generation == _generation) _isOperating = false;
      if (generation == _generation && _refreshPending) {
        _refreshPending = false;
        scheduleMicrotask(_requestRefresh);
      }
    }
  }
}
