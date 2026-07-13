import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/dashboard/dashboard_providers.dart';
import 'package:focusly/features/dashboard/presentation/state/dashboard_state.dart';

final class DashboardNotifier extends Notifier<DashboardState> {
  Future<void>? _loadOperation;

  @override
  DashboardState build() {
    ref.watch(publicAuthSessionProvider).user?.id;
    scheduleMicrotask(load);
    return const DashboardState();
  }

  Future<void> load() {
    final activeOperation = _loadOperation;
    if (activeOperation != null) return activeOperation;
    final operation = _performLoad();
    _loadOperation = operation;
    operation.whenComplete(() {
      if (identical(_loadOperation, operation)) _loadOperation = null;
    });
    return operation;
  }

  Future<void> _performLoad() async {
    final userId = ref.read(publicAuthSessionProvider).user?.id;
    if (userId == null) {
      state = const DashboardState(
        isLoading: false,
        errorMessage: 'Necesitas una sesión válida para ver el inicio.',
      );
      return;
    }

    final hasContent = state.profile != null && state.companion != null;
    if (!hasContent) {
      state = state.copyWith(isLoading: true, clearError: true);
    }
    try {
      final repository = ref.read(dashboardOnboardingRepositoryProvider);
      final profileFuture = repository.getProfile(userId);
      final companionFuture = repository.getCompanion(userId);
      final profile = await profileFuture;
      final companion = await companionFuture;
      if (ref.read(publicAuthSessionProvider).user?.id != userId) return;
      if (profile == null || companion == null) {
        state = const DashboardState(
          isLoading: false,
          errorMessage: 'No pudimos encontrar tu configuración inicial.',
        );
        return;
      }
      state = DashboardState(
        profile: profile,
        companion: companion,
        isLoading: false,
      );
    } on Object {
      if (ref.read(publicAuthSessionProvider).user?.id != userId) return;
      state = hasContent
          ? state.copyWith(isLoading: false)
          : const DashboardState(
              isLoading: false,
              errorMessage:
                  'No pudimos preparar tu inicio. Inténtalo nuevamente.',
            );
    }
  }
}
