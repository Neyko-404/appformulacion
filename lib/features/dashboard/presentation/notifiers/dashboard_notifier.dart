import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/authentication/auth_session_provider.dart';
import 'package:focusly/features/dashboard/dashboard_providers.dart';
import 'package:focusly/features/dashboard/presentation/state/dashboard_state.dart';

final class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    ref.watch(publicAuthSessionProvider).user?.id;
    scheduleMicrotask(load);
    return const DashboardState();
  }

  Future<void> load() async {
    final userId = ref.read(publicAuthSessionProvider).user?.id;
    if (userId == null) {
      state = const DashboardState(
        isLoading: false,
        errorMessage: 'Necesitas una sesión válida para ver el inicio.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
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
      state = const DashboardState(
        isLoading: false,
        errorMessage: 'No pudimos preparar tu inicio. Inténtalo nuevamente.',
      );
    }
  }
}
