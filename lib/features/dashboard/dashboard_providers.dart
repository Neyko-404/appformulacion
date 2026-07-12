import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/dashboard/presentation/notifiers/dashboard_notifier.dart';
import 'package:focusly/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/onboarding/onboarding_providers.dart';

final dashboardOnboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => ref.watch(onboardingRepositoryProvider),
);

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);
