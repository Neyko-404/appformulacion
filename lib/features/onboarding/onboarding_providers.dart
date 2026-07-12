import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focusly/features/onboarding/data/data_sources/isar_onboarding_local_data_source.dart';
import 'package:focusly/features/onboarding/data/data_sources/onboarding_local_data_source.dart';
import 'package:focusly/features/onboarding/data/repositories/in_memory_onboarding_repository.dart';
import 'package:focusly/features/onboarding/data/repositories/isar_onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:focusly/features/onboarding/domain/services/onboarding_validator.dart';
import 'package:focusly/features/onboarding/presentation/notifiers/onboarding_notifier.dart';
import 'package:focusly/features/onboarding/presentation/state/onboarding_state.dart';
import 'package:focusly/services/local_database/local_database_provider.dart';

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  final database = ref.watch(localDatabaseProvider);
  if (database == null) {
    throw StateError('Local database is unavailable outside bootstrap.');
  }
  return IsarOnboardingLocalDataSource(database);
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  if (ref.watch(localDatabaseProvider) == null) {
    return InMemoryOnboardingRepository();
  }
  return IsarOnboardingRepository(ref.watch(onboardingLocalDataSourceProvider));
});

final onboardingValidatorProvider = Provider<OnboardingValidator>(
  (ref) => const OnboardingValidator(),
);

final onboardingClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
      OnboardingNotifier.new,
    );
